#!/bin/sh
# Public integration only. Core code arrives as a version-pinned binary archive.
set -eu
umask 077
fail() { echo "TensorViz: $*" >&2; exit 1; }
prepare=false
if [ "${1:-}" = --prepare-runtime ]; then
  [ "$#" -eq 1 ] || fail '--prepare-runtime does not accept additional arguments.'
  prepare=true
fi
plugin=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd -P)
host="$(uname -s)-$(uname -m)"
case "$host" in
  Darwin-arm64) platform=darwin-arm64; abi=cpython-312-darwin;;
  Linux-x86_64) platform=linux-x64; abi=cpython-312-x86_64-linux-gnu;;
  *) fail "Unsupported MCP execution host: $host. Compiled targets are macOS Apple Silicon and glibc Linux x64. No runtime was downloaded.";;
esac
lock="$plugin/runtime-lock.json"
# macOS has plutil; Linux needs system Python3 only for strict JSON metadata reads.
# Model/service execution separately requires the native runtime's CPython 3.12 ABI.
if [ "$platform" = darwin-arm64 ]; then
  format=$(/usr/bin/plutil -extract formatVersion raw -o - "$lock")
  case "$format" in
    1) prefix='';;
    2) prefix="runtimes.$platform.";;
    *) fail 'Invalid runtime lock format.';;
  esac
  field() { /usr/bin/plutil -extract "$prefix$1" raw -o - "$lock"; }
  lock_version=$(/usr/bin/plutil -extract version raw -o - "$lock")
else
  libc=$(/usr/bin/getconf GNU_LIBC_VERSION 2>/dev/null) || fail 'Linux runtime requires glibc 2.35 or newer.'
  case "$libc" in 'glibc '*) ;; *) fail 'Linux runtime requires glibc 2.35 or newer.';; esac
  libc_version=${libc#glibc }
  major=${libc_version%%.*}
  minor=${libc_version#*.}
  case "$major:$minor" in *[!0-9:]*|:*) fail 'Invalid glibc version.';; esac
  [ "$major" -gt 2 ] || { [ "$major" -eq 2 ] && [ "$minor" -ge 35 ]; } || fail 'Linux runtime requires glibc 2.35 or newer.'
  [ -x /usr/bin/python3 ] || fail 'Linux launcher metadata requires /usr/bin/python3.'
  field() {
    /usr/bin/python3 -I -B -c '
import json, sys
with open(sys.argv[1]) as stream: lock = json.load(stream)
if lock.get("formatVersion") == 2:
    entry = lock["runtimes"][sys.argv[2]]
    if entry.get("formatVersion") != 1 or entry.get("version") != lock.get("version"): raise ValueError("Runtime version mismatch")
elif lock.get("formatVersion") == 1: entry = lock
else: raise ValueError("Invalid runtime lock format")
value = entry[sys.argv[3]]
if type(value) not in (str, int) or "\n" in str(value) or "\r" in str(value): raise ValueError("Invalid runtime field")
print(value)
' "$lock" "$platform" "$1"
  }
  lock_version=$(field version) || fail "No valid $platform runtime in this installation. No runtime was downloaded."
fi
version=$(field version) || fail "No valid $platform runtime in this installation. No runtime was downloaded."
[ "$version" = "$lock_version" ] || fail 'Runtime version mismatch.'
[ "$(field platform)" = "$platform" ] || fail "No $platform runtime in this installation. No runtime was downloaded."
[ "$(field pythonABI)" = "$abi" ] || fail 'Invalid runtime Python ABI.'
sha=$(field sha256)
url=$(field url)
bytes=$(field bytes)
case "$sha" in *[!a-f0-9]*|'') fail 'Invalid runtime digest.';; esac
[ "${#sha}" -eq 64 ] || fail 'Invalid runtime digest.'
case "$bytes" in *[!0-9]*|'') fail 'Invalid runtime size.';; esac
[ "$bytes" -gt 0 ] && [ "$bytes" -le 268435456 ] || fail 'Invalid runtime size.'
case "$url" in https://*) ;; *) fail 'Runtime downloads require HTTPS.';; esac
case "$url" in *'@'*|*'#'*|*[[:space:]]*) fail 'Invalid runtime URL.';; esac
if [ "$platform" = darwin-arm64 ]; then
  checksum() { /usr/bin/shasum -a 256 "$1" | cut -d ' ' -f 1; }
else
  checksum() { sha256sum "$1" | cut -d ' ' -f 1; }
fi
if [ -n "${TENSORVIZ_RUNTIME_CACHE_DIR:-}" ]; then
  case "$TENSORVIZ_RUNTIME_CACHE_DIR" in /*) ;; *) fail 'TENSORVIZ_RUNTIME_CACHE_DIR must be an absolute path.';; esac
  cache=$TENSORVIZ_RUNTIME_CACHE_DIR
elif [ "$platform" = darwin-arm64 ]; then
  cache="${HOME:?}/Library/Caches/dev.tensorviz/runtime"
else
  cache="${XDG_CACHE_HOME:-${HOME:?}/.cache}/dev.tensorviz/runtime"
fi
mkdir -p "$cache"
[ ! -L "$cache" ] || fail 'The runtime cache must not be a symbolic link.'
archive="$cache/$sha.tar.gz"
download=''
session=''
child=''
cleanup() {
  if [ -n "$child" ]; then kill "$child" 2>/dev/null || true; wait "$child" 2>/dev/null || true; fi
  [ -z "$download" ] || rm -f -- "$download"
  [ -z "$session" ] || rm -rf -- "$session"
}
trap cleanup 0
trap 'exit 130' INT
trap 'exit 143' TERM HUP
if [ ! -f "$archive" ]; then
  download=$(mktemp "$cache/.download.XXXXXX")
  echo "TensorViz: downloading runtime $version for reuse by later connections." >&2
  curl --fail --silent --show-error --location --proto '=https' --proto-redir '=https' \
    --connect-timeout 15 --max-time 300 --max-filesize "$bytes" --output "$download" "$url" < /dev/null &
  child=$!
  wait "$child" || fail 'Runtime download failed. Retry the plugin connection.'
  child=''
  [ "$(wc -c < "$download" | tr -d '[:space:]')" = "$bytes" ] || fail 'Runtime size mismatch. Nothing was executed.'
  [ "$(checksum "$download")" = "$sha" ] \
    || fail 'Runtime checksum mismatch. Nothing was executed.'
  mv -f -- "$download" "$archive"
  download=''
fi
[ ! -L "$archive" ] || fail 'The cached archive must not be a symbolic link.'
[ "$(wc -c < "$archive" | tr -d '[:space:]')" = "$bytes" ] || fail "Cached runtime is damaged (size mismatch). Remove $archive and reconnect. Nothing was executed."
[ "$(checksum "$archive")" = "$sha" ] \
  || fail "Cached runtime is damaged. Remove $archive and reconnect. Nothing was executed."
if [ "$prepare" = true ]; then
  echo "TensorViz: runtime $version verified and cached; reconnect the plugin." >&2
  exit 0
fi
# Extract anew from the verified archive, so modified unpacked caches cannot run.
session=$(mktemp -d "${TMPDIR:-/tmp}/tensorviz-native.XXXXXX")
/usr/bin/tar -xzf "$archive" -C "$session"
[ -x "$session/tensorviz-host" ] || fail 'Runtime archive has no executable host.'
# Inductor can create model-derived cache files even during model inspection.
# Keep this cache in our private session, not the shared temp directory or an
# inherited caller cache. Preserve TMPDIR so cross-host locks still coordinate.
TORCHINDUCTOR_CACHE_DIR="$session/.torchinductor"
export TORCHINDUCTOR_CACHE_DIR
# Noninteractive sh gives asynchronous jobs /dev/null on fd 0; save MCP stdin first.
exec 3<&0
"$session/tensorviz-host" "$@" <&3 3<&- &
child=$!
exec 3<&-
set +e
wait "$child"
status=$?
child=''
exit "$status"
