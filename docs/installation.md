# Installation notes

## Contents

- [Install from a local repository](#install-from-a-local-repository)
- [T3 Code and large graphs](#t3-code-and-large-graphs)
- [Troubleshooting](#troubleshooting)
- [Update or remove](#update-or-remove)
- [Documentation verification](#documentation-verification)
- [Release export preservation — October 13, 2026](#release-export-preservation-october-13-2026)

The [README](../README.md) contains the download links, client installation
commands, and first-use prompts for the published 0.3.110 preview. This guide covers
local repository installation, updates, and common setup problems.

The compiled candidate targets macOS Apple Silicon or Linux x64 with glibc >=2.35
and CPython 3.12. Linux needs `/usr/bin/python3` for metadata plus `curl`,
`sha256sum` and `tar`. Windows, Linux ARM64, Intel Macs and musl are unsupported.
The execution host must have its own native entry in `runtime-lock.json`; the
separate VS Code extension's platform checks do not establish compatibility.
Existing v0.3.104 releases remain Darwin-only. See the
[tool and platform inventory](../BUILD.md#tools-and-integration-boundaries).

For SSH, install and execute on the model's server. The desktop OS does not select
the runtime. A raw localhost graph URL belongs to that server; forward its port or
use a compatible embedded panel. Real SSH-network acceptance is separate from
local launcher and Codex tests.

## Install from a local repository

Download and extract [the 0.3.110 catalog ZIP](https://github.com/tensorviz-org/tensorviz-plugins/releases/download/v0.3.110/tensorviz-catalog-0.3.110.zip)
into a persistent folder, for example `~/tensorviz-catalog-0.3.110`.
It contains `.agents/plugins/marketplace.json`, `.claude-plugin/marketplace.json`,
and the plugin directories with pinned runtime locks. The separate per-client
plugin ZIPs do not contain the marketplace catalogs.

The public distribution repository and its version tags contain the audited
integration catalog. The private `tensorviz` source repository is not an
installation catalog. The catalog ZIP provides the same complete export.

Then choose your client, replacing the example path with the absolute path to
the extracted catalog:

```sh
codex plugin marketplace add /absolute/path/to/tensorviz-catalog-0.3.110
codex plugin add tensorviz@tensorviz-standalone
```

```sh
claude plugin marketplace add /absolute/path/to/tensorviz-catalog-0.3.110
claude plugin install tensorviz@tensorviz-standalone --scope user
```

For Cursor, copy the catalog's complete `cursor/plugins/tensorviz` directory
to `~/.cursor/plugins/local/tensorviz`, then reload Cursor. Do not copy the whole
repository or its common `plugins/tensorviz` directory into that destination.
Keep the extracted catalog folder available for local marketplace refreshes.
Local installation still needs internet access for the first runtime download.

## T3 Code and large graphs

Follow [T3 Code setup](../BUILD.md#t3-code) using the selected Codex provider's
binary and home. A plugin installed in a different profile will not appear in T3.
Start a new thread or restart the agent session after an update. Keep one TensorViz
connection enabled. The originating session must remain available for the panel.

The 0.3.20 integration supports inline/fullscreen display, selection context,
captured-detail inspection, refresh approval, and panel restoration. Acceptance
on the Mac desktop app covered eight CPU workloads, including ViT-H/14 with 632M
parameters, a complete 4,100-node graph, and partial graphs up to 5,064 nodes.
These workload results were recorded on the T3 development build; the release
candidate has its own package and T3 protocol acceptance checks.

A successful forward pass can still produce a partial execution recording.
TensorViz caps each recording at 4 MiB and displays **Partial capture — recording
size limit reached** when that limit is reached. **Passed** refers to the model's
forward result; it does not mean every operation was recorded. GPU, training,
T3 mobile, remote hosts, and non-Codex providers are outside this acceptance scope.

## Troubleshooting

| Problem | What to check |
| --- | --- |
| Launcher reports macOS-only support or no linux-x64 runtime | The old v0.3.104 lock is Darwin-only. Use a later catalog only after its Linux asset is published. Changing Python or bypassing checks cannot supply a missing binary. |
| Unsupported execution host or glibc error | Use macOS Apple Silicon or Linux x64 with glibc >=2.35 and a matching runtime pin. ARM Linux, musl, Windows and Intel Mac are unsupported. |
| `codex` or `claude` is not found | Install the corresponding client CLI using the links in the README, reopen your terminal, and check that its plugin commands are available. |
| `plugin` is an unknown command | Update your coding client to a version with plugin support, then reopen your terminal. |
| Marketplace catalog not found after downloading a ZIP | The release plugin ZIP is not a marketplace. Use the complete catalog ZIP above, not a plugin ZIP or source archive. |
| T3 captures a model but does not show an interactive panel | Use a Codex thread and the tested T3 nightly or a newer compatible build. Check the provider profile; on stable 0.0.45, request `open_graph_view` for the local browser fallback. |
| T3 says a panel is unavailable | Send a message to resume the originating agent session, then ask the agent to reopen the graph. |
| No tensorViz tools in a chat | Check that the plugin is enabled, then start a new chat in the model project. Restart the client if needed. |
| Duplicate tensorViz tools or the wrong host | Disable the old companion plugin or manual tensorViz MCP entry in that client's settings. Keep one host enabled. |
| Cursor does not discover the local plugin | Confirm that `~/.cursor/plugins/local/tensorviz/.cursor-plugin/plugin.json` exists, reload the window, and check whether your organization allows local plugin imports. An installed marketplace copy takes precedence. |
| Runtime download fails | Check access to GitHub Releases, then reconnect. The launcher needs the runtime URL pinned in `runtime-lock.json`. |
| Cached runtime checksum fails | Remove only the damaged archive named in the error, then reconnect to download a fresh verified copy. Do not disable checksum verification. |
| Python environment is rejected | Select CPython 3.12 for this compiled preview. Compatibility checks for the separate VS Code extension do not apply to this binary. |
| Setup needs arguments, inputs, packages, or model assets | Supply the values your model actually requires and complete setup in the selected environment. Saved `tensorviz.toml` recipes are reused. |
| Capture succeeds but no graph appears | Ask the agent to show the Model graph panel, or request the local browser graph. Display and capture are separate steps. |

The verified runtime archive is cached under
`~/Library/Caches/dev.tensorviz/runtime` on macOS or
`${XDG_CACHE_HOME:-$HOME/.cache}/dev.tensorviz/runtime` on Linux. The launcher checks it on each connection
and extracts separate session files. See [runtime details](../BUILD.md).

## Update or remove

To update, download the new catalog ZIP, keep the previous complete folder for
rollback, and replace the catalog directory with the complete new export. Do not
merge files from different releases. Then refresh Codex:

```sh
codex plugin marketplace upgrade tensorviz-standalone
```

Then use Codex's plugin update/install controls and start a new chat. For Claude Code:

```sh
claude plugin update tensorviz@tensorviz-standalone
```

Restart the Claude Code session afterward. A locally extracted catalog stays at
its version until you explicitly replace it with a new complete catalog export.

For Cursor, close chats using tensorViz, move the old `tensorviz` plugin directory
outside `~/.cursor/plugins/local`, then extract the complete new Cursor ZIP into
a fresh `~/.cursor/plugins/local/tensorviz` directory. Reload Cursor and start a
new chat. Keep the prior complete folder outside the discovery directory for
rollback; do not combine files from different releases.

To uninstall, close the client's tensorViz chats and use the appropriate command:

```sh
codex plugin remove tensorviz@tensorviz-standalone
```

```sh
claude plugin uninstall tensorviz@tensorviz-standalone --scope user
```

For a local Cursor installation, remove only
`~/.cursor/plugins/local/tensorviz` and reload Cursor. Removing the plugin does not
remove your model code, project recipes, Python environments, runtime cache, or
saved tensorViz permission. See [privacy and local data](../PRIVACY.md).

## Documentation verification

The October 11, 2026 README update documents the public compiled integration rather
than the older source-preview build. Its commands were checked against the
installed Codex and Claude Code CLI help, the client marketplace manifests, and
the official [Codex](https://developers.openai.com/plugins/build/plugins),
[Claude Code](https://code.claude.com/docs/en/discover-plugins), and
[Cursor](https://cursor.com/docs/plugins#test-plugins-locally) documentation.
Both published 0.3.19 plugin ZIPs were downloaded to check their extraction layout.
The runtime lock identifies macOS Apple Silicon and CPython 3.12.
Local links and section anchors, shell command syntax, and all publication hashes
were checked. All 11 external documentation and download links returned HTTP 200
without credentials.

The public README now explains supported hardware, which ZIP to choose, automatic
runtime downloads, installation in each client, and how to confirm a first capture.
This companion guide records local installation, troubleshooting, updates, and
removal. `PUBLICATION.json` tracks the updated documentation hashes. Future release
exports should preserve these guides and update their versioned download links.

This documentation check does not establish a new end-to-end client acceptance
result or an official marketplace listing. Runtime behavior and release assets
are unchanged. See the [support scope](../SUPPORT.md).

<a id="release-export-preservation-october-13-2026"></a>

## Release export preservation — October 13, 2026

The private release exporter now includes this guide in the root catalog and in
both plugin ZIPs, preserves the complete installation README, and substitutes
the generated release version in download links. Runtime checks and ZIP/source
audits remain separate from documentation checks. T3's guide is included in
BUILD.md for both installed plugins as well as the repository.

## 0.3.104 source and asset audit — November 7, 2026

All four published assets were downloaded and checked against their public
SHA-256 digests. The runtime archive and JSON manifest match both client locks.
The common ZIP has 15 files and the Cursor ZIP has 16; before these documentation
changes, each file matched its catalog tree. The exported skill and shell launcher
also match merged source revision `0e17eac`. No newer plugin skill or separate
plugin command directory was missing from the export.

The host's source inventory registers 29 tools, including four app-only tools;
see the [complete inventory](../BUILD.md#tools-and-integration-boundaries).
Fresh installation into a disposable Codex 0.166.0 profile installed and enabled
0.3.104. On Linux, both catalog launchers, fresh ZIP extractions and the installed
Codex copy returned the expected unsupported-platform error without downloading a
runtime. An isolated prebuilt source-development Node bundle (0.3.61) separately
passed MCP initialization, discovery of all 29 tools, retained-analysis rejection
without a model, and Model graph resource checks. These checks did not execute a
model or verify native Mac execution or client GUI rendering. The earlier dated
client results above remain historical.

The integration catalog documentation was updated separately from the release assets. Existing
v0.3.104 release ZIPs are unchanged. Future releases regenerate these guides from
source templates; the [release ownership note](../BUILD.md#release-ownership)
describes how to preserve documentation changes in the source repository.
