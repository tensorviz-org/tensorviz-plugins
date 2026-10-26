# Installation notes

The [README](../README.md) contains the download links, client installation
commands, and first-use prompts for the published 0.3.48 preview. This guide covers
local repository installation, updates, and common setup problems.

The standalone plugin currently requires macOS Apple Silicon and CPython 3.12.
The separate VS Code extension's broader Python and platform checks do not
establish compatibility for this compiled plugin.

## Install from a local repository

The release ZIPs contain plugin files directly. Codex and Claude Code marketplace
registration instead requires the repository's catalog and plugin directories.
Download and extract [the 0.3.48 repository ZIP](https://github.com/tensorviz-org/tensorviz-plugins/archive/refs/tags/v0.3.48.zip)
into a persistent folder, or clone the tagged repository:

```sh
git clone --branch v0.3.48 https://github.com/tensorviz-org/tensorviz-plugins.git
```

Then choose your client, replacing the example path with the absolute path to
the extracted or cloned repository:

```sh
codex plugin marketplace add /absolute/path/to/tensorviz-plugins
codex plugin add tensorviz@tensorviz-standalone
```

```sh
claude plugin marketplace add /absolute/path/to/tensorviz-plugins
claude plugin install tensorviz@tensorviz-standalone --scope user
```

For Cursor, copy the repository's complete `cursor/plugins/tensorviz` directory
to `~/.cursor/plugins/local/tensorviz`, then reload Cursor. Do not copy the whole
repository or its common `plugins/tensorviz` directory into that destination.
Keep the original repository folder available for local marketplace refreshes.
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
| `codex` or `claude` is not found | Install the corresponding client CLI using the links in the README, reopen your terminal, and check that its plugin commands are available. |
| `plugin` is an unknown command | Update your coding client to a version with plugin support, then reopen your terminal. |
| Marketplace catalog not found after downloading a ZIP | The release plugin ZIP is not a marketplace. Use the repository installation commands in the README or the complete repository download above. |
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
`~/Library/Caches/dev.tensorviz/runtime`. The launcher checks it on each connection
and extracts separate session files. See [runtime details](../BUILD.md).

## Update or remove

For a GitHub-backed Codex installation, refresh the marketplace:

```sh
codex plugin marketplace upgrade tensorviz-standalone
```

Then use Codex's plugin update/install controls and start a new chat. For Claude Code:

```sh
claude plugin update tensorviz@tensorviz-standalone
```

Restart the Claude Code session afterward. A local repository pinned to a release
tag stays at that version until you explicitly update or replace that checkout.

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

## Release export preservation — October 13, 2026

The private release exporter now includes this guide in the root catalog and in
both plugin ZIPs, preserves the complete installation README, and substitutes
the generated release version in download links. Runtime checks and ZIP/source
audits remain separate from documentation checks. T3's guide is included in
BUILD.md for both installed plugins as well as the repository.
