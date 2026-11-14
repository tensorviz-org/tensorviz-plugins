# Install the integration

This page is the compiled plugin archive's install guide. That archive cannot
rebuild the runtime; the launcher downloads the pinned artifact, and users do
not need a source checkout or build tools to use it. The public distribution repository contains only the audited integration,
not the private source history.
`runtime-lock.json` pins the exact platform, CPython ABI, URL and SHA-256 digest.
The candidate's download URL must be published before installation works outside
the release test environment.

Claude Code supports the existing public catalog:

```sh
claude plugin marketplace add tensorviz-org/tensorviz-plugins
claude plugin install tensorviz@tensorviz-standalone --scope user
```

For Codex:

```sh
codex plugin marketplace add tensorviz-org/tensorviz-plugins
codex plugin add tensorviz@tensorviz-standalone
```

For a local catalog, extract `tensorviz-catalog-0.1.44.zip` into a persistent
directory and use that absolute path instead. Never register the private source
repository as a marketplace. The compiled runtime downloads on the first
connection. Updating the plugin selects its new pinned runtime; an existing chat
keeps its session's resources. Start a new chat to use the new version.

For local ZIP installs, replace the catalog with a complete new catalog ZIP,
keeping the prior complete directory for rollback. For Claude, `claude plugin update tensorviz@tensorviz-standalone` refreshes the
marketplace and installs a changed version. Automatic updates for custom Claude
marketplaces are off by default; the user controls that setting. For Codex, refresh
the marketplace through `codex plugin marketplace upgrade tensorviz-standalone`
and then run `codex plugin add tensorviz@tensorviz-standalone --json`. Verify the
returned installed version/path and start a new chat. Refresh alone does not
replace the installed cache. Run both commands in the same Codex profile and
execution environment as the chat, not a different local or remote host.

For Cursor local evaluation, use its supported local plugin import with the
complete `cursor/plugins/tensorviz` directory. Account or organization policy can
restrict local imports. An official directory listing is a separate approval;
these instructions do not claim marketplace acceptance.

## Tools and integration boundaries

The 0.1.44 host registers **29 MCP tools**. Clients that hide app-only tools
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
Canvas agent tools and repository-development skills are not part of this
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

### Compiled platform matrix

The 0.1.44 candidate can pin `darwin-arm64` and `linux-x64` runtime archives,
each with its own JSON lock manifest. The backend requires CPython 3.12 with ABI
`cpython-312-darwin` or `cpython-312-x86_64-linux-gnu` respectively. Linux requires
glibc >=2.31; Windows, Linux ARM64, Intel Mac and musl builds are unsupported.
No separate Node.js install or source fallback is provided.

Format-1 locks still describe one runtime. Format-2 catalogs map platforms to
independently hashed, size-bounded HTTPS assets of the same version. The launcher
uses `uname` on the MCP execution host, including an SSH server. It refuses absent
platform entries before download; Python pins alone cannot supply a native asset.
The published v0.3.104 snapshot remains Darwin-only. A source fix or documentation
export does not publish new binaries or prove native acceptance on both platforms.

### Release ownership

The local exporter reads `plugin/packaging/public/` and preserves version
placeholders in these source templates. `PUBLICATION.json` records the exact
integration inventory, hashes and runtime provenance. Both client locks must
match the publication lock. The source repository native release workflow publishes
runtime archives, client ZIPs, and the catalog ZIP under `v0.1.44`,
in the public distribution repository. Tags identify audited export commits;
PUBLICATION.json binds each export to its reviewed private source SHA. It never
replaces source main or copies private Git history.
Local export alone does not publish an asset.

## T3 Code

T3 Code is not a supported install target in this source tree. Use
[the installation guide](docs/installation.md) for Claude Code, Codex, and Cursor.

## Updates and removal

Start a new chat after installation. Keep one TensorViz host enabled per client.
Use the client's plugin management to update, disable or uninstall. Installation
does not alter global tool approval settings or replace other MCP connections.

The launcher caches the verified archive under
`~/Library/Caches/dev.tensorviz/runtime` on macOS or
`${XDG_CACHE_HOME:-$HOME/.cache}/dev.tensorviz/runtime` on Linux. It extracts private session files for
each connection and removes them when that connection ends. A checksum mismatch
stops startup; remove the reported damaged archive and reconnect to download it
again. No source fallback is available. Updates use a new pinned archive; an older
integration and its matching archive can be reinstalled for rollback.

## Isolated runtime caches

This option is available in new source candidates. Published 0.3.109 does not
read `TENSORVIZ_RUNTIME_CACHE_DIR`; changing it there does not isolate the cache.

Set `TENSORVIZ_RUNTIME_CACHE_DIR` to an absolute task-owned directory in the MCP
server environment to keep downloaded runtime archives separate from the normal
user cache. This does not change the client profile or Python environment. The
default cache locations remain unchanged when the variable is absent. Relative
paths and symbolic-link cache directories are rejected; size, SHA-256 and HTTPS
checks still apply on every launch. A damaged-cache error identifies the exact
archive to remove before reconnecting.

Client profiles and TensorViz state are separate: use the client's supported
profile controls and `TENSORVIZ_DATA_DIR` for isolated permission, service and
workspace state. Do not redirect the user's home, copy credentials or assume a
second desktop instance uses an isolated profile. Verify the actual app process
and profile before changing plugin settings.
