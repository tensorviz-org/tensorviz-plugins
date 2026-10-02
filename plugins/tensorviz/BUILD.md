# Install the integration

This repository contains the integration only. It cannot rebuild the private
runtime, and users do not need a source checkout or build tools to use it.
`runtime-lock.json` pins the exact platform, CPython ABI, URL and SHA-256 digest.
The candidate's download URL must be published before installation works outside
the release test environment.

For a local evaluation checkout, Claude Code supports:

```sh
claude plugin marketplace add /absolute/path/to/integration
claude plugin install tensorviz@tensorviz-standalone --scope user
```

For Codex's local plugin flow:

```sh
codex plugin marketplace add /absolute/path/to/integration
codex plugin add tensorviz@tensorviz-standalone
```

For published releases, replace the local checkout path in the marketplace command
with `tensorviz-org/tensorviz-plugins`. The compiled runtime downloads on the first
connection. Updating the plugin selects its new pinned runtime; an existing chat
keeps its session's resources. Start a new chat to use the new version.

For Claude, `claude plugin update tensorviz@tensorviz-standalone` refreshes the
marketplace and installs a changed version. Automatic updates for custom Claude
marketplaces are off by default; the user controls that setting. For Codex, refresh
the marketplace through `codex plugin marketplace upgrade tensorviz-standalone`
and use the client's plugin update/install controls.

For Cursor local evaluation, use its supported local plugin import with the
complete `cursor/plugins/tensorviz` directory. Account or organization policy can
restrict local imports. An official directory listing is a separate approval;
these instructions do not claim marketplace acceptance.

Start a new chat after installation. Keep one TensorViz host enabled per client.
Use the client's plugin management to update, disable or uninstall. Installation
does not alter global tool approval settings or replace other MCP connections.

The launcher caches the verified archive under
`~/Library/Caches/dev.tensorviz/runtime`. It extracts private session files for
each connection and removes them when that connection ends. A checksum mismatch
stops startup; remove the reported damaged archive and reconnect to download it
again. No source fallback is available. Updates use a new pinned archive; an older
integration and its matching archive can be reinstalled for rollback.
