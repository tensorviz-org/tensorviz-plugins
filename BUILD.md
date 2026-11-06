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

## Tools and integration boundaries

The 0.3.104 host registers **29 MCP tools**. Clients that hide app-only tools
expose **25** to the agent. Discover the installed server's tools and
`list_models` capabilities before use.

| Purpose | Tools |
| --- | --- |
| Discover and inspect graphs | `list_models`, `get_graph`, `inspect_nodes`, `get_selection`, `focus_view` |
| Capture and environment | `open_graph`, `get_execution_environment` |
| Retained execution evidence | `list_captures`, `inspect_capture`, `get_model_context`, `find_computation`, `query_computation`, `analyze_computation_change` |
| Saved setup | `get_graph_setup`, `suggest_graph_inputs`, `configure_graph_setup`, `configure_graph_environment` |
| Validation runs | `validate_model`, `get_run`, `inspect_run`, `cancel_run`, `compare_runs` |
| Graph display and source diff | `open_graph_view`, `open_graph_panel`, `open_graph_diff` |
| Model graph app only | `graph_panel_read`, `graph_panel_exchange`, `detach_graph_panel`, `close_graph_panel` |

The coding agent must not call the four app-only transport tools. Reading retained
evidence does not recapture a model. A source diff does not measure either
revision. Capture, display and model success each require their own evidence.
The standalone host does not advertise source proposals, training diagnostics,
a native editor or analytics.

Both catalog trees include the canonical `model-workflow` skill from the merged
plugin source. That source has no separate plugin slash-command directory.
Private Canvas agent tools and repository-development skills are not part of this
integration. The source-development Node launcher, installers and permission
helpers are also intentionally excluded: they require a complete source bundle
and are not a fallback for the compiled public runtime. Installation and updates
use the coding client's plugin controls.

The common catalog points Codex and Claude Code at `plugins/tensorviz`. Cursor's
catalog points at `cursor/plugins/tensorviz`, whose MCP configuration uses
`${CURSOR_PLUGIN_ROOT}`. Copy the complete tree intended for your client; the
launcher variables differ. T3 uses its selected Codex provider. These files do not
establish Claude Cowork or other client compatibility or an official directory
listing.

### Published platforms

The 0.3.104 release contains the common plugin ZIP, the Cursor plugin ZIP, one
`darwin-arm64` runtime archive and its JSON lock manifest. The compiled backend
requires CPython 3.12 on macOS Apple Silicon. There are no published Linux,
Windows or Intel Mac runtime builds. On Linux, the public shell launcher exits
with an unsupported-platform error before downloading anything; it cannot run
this compiled release there.

The private source's managed-Python pins include Linux x64 and Windows x64.
Those pins describe source-development environments, not published native plugin
assets. Copying that source launcher or changing the public lock would not supply
the missing compiled builds. No separate Node.js install is needed for the
published Mac runtime.

### Release ownership

`PUBLICATION.json` records the public integration file hashes and the original
runtime source revision. Documentation fixes in this checkout update those file
hashes without changing runtime provenance, version, URLs or runtime digests.
The published 0.3.104 ZIPs remain immutable snapshots and will retain their older
documentation; use this checkout's catalog for these documentation fixes.

The private exporter owns a closed public-file allowlist and regenerates all three
catalogs, both client trees and the documentation on release. Public-only changes
to these guides will be overwritten unless the corresponding
`docs/public-plugin/README.md`, `BUILD.md` and `docs/installation.md` templates are
updated in the source repository. That follow-up must preserve version placeholders
and the runtime allowlist. Local verification scripts are kept outside this
checkout so the existing release audit can still accept its exact file inventory.

## T3 Code

T3 Code uses the TensorViz plugin installed in its selected Codex provider's
configuration. There is no separate T3 marketplace or TensorViz server to add.
Use a Codex thread for the interactive MCP App; T3 currently renders other
providers' MCP calls as ordinary tool results.
The embedded graph was tested with T3
`0.0.46-nightly.20261012.3035`. Stable `0.0.45` captures and inspects models but
does not render the app; use the browser fallback there. TensorViz 0.3.20 includes these compatibility changes.
Use 0.3.20 or newer for this installation flow.

1. In T3 **Settings → Providers → Codex**, check the binary and **CODEX_HOME path**
   for the selected environment. Install the Codex plugin using the commands above
   with that binary and home. A blank home uses Codex's normal home. If TensorViz
   is already enabled there, reuse it rather than adding a second MCP connection.
2. Start a new Codex thread in the model project, or use **Restart agent session**
   after installing/updating the plugin. Installation in a different Codex profile
   does not configure this T3 provider.
3. Ask: “Use TensorViz to capture model.py class MyModel with its saved inputs,
   then call open_graph_panel to show the interactive Model graph in this chat.”
   Supply your actual model file/class and resolve any missing Python or input setup.
4. The graph appears inline and can expand to fullscreen. Polling, selection and
   reading captured details use a read-only tool. Refresh/setup actions retain
   T3's tool approval and TensorViz's existing execution permission.

The panel needs the originating agent session to remain available. If T3 says
it is unavailable, send a message in that thread and reopen the panel. If no app
appears, confirm the thread uses Codex and a current T3 version, then request
`open_graph_view` for the local browser fallback.

Install on the machine where T3 runs Codex and the model. A localhost browser
link points to that machine; it is not automatically reachable from a phone or
another computer. The native runtime's platform limits still apply. T3 mobile,
remote environments and other providers require separate acceptance checks.

References: [T3 MCP Apps](https://github.com/pingdotgg/t3code/blob/main/docs/user/html-renders.md),
[provider homes](https://github.com/pingdotgg/t3code/blob/main/docs/user/providers-codex.md),
[restarting agent sessions](https://github.com/pingdotgg/t3code/blob/main/docs/user/composer.md#commands-and-skills).

## Updates and removal

Start a new chat after installation. Keep one TensorViz host enabled per client.
Use the client's plugin management to update, disable or uninstall. Installation
does not alter global tool approval settings or replace other MCP connections.

The launcher caches the verified archive under
`~/Library/Caches/dev.tensorviz/runtime`. It extracts private session files for
each connection and removes them when that connection ends. A checksum mismatch
stops startup; remove the reported damaged archive and reconnect to download it
again. No source fallback is available. Updates use a new pinned archive; an older
integration and its matching archive can be reinstalled for rollback.
