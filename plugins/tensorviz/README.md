> Compiled release archive template. Workflows run in `tensorviz-org/tensorviz`;
> public releases and the installation catalog stay in `tensorviz-org/tensorviz-plugins`.

# tensorViz for coding agents

## Contents

- [Requirements](#requirements)
- [Download](#download)
- [Install in Codex](#install-in-codex)
- [Install in Claude Code](#install-in-claude-code)
- [Install in Cursor](#install-in-cursor)
- [Install in T3 Code](#install-in-t3-code)
- [Use tensorViz](#use-tensorviz)
- [External services and local data](#external-services-and-local-data)

tensorViz lets your coding agent show a local PyTorch model as an interactive
graph. See how tensors move between layers, inspect their measured shapes, and
refresh the graph after editing your model.

**Choose your app:** [Codex](#install-in-codex) ·
[Claude Code](#install-in-claude-code) · [Cursor](#install-in-cursor) ·
[T3 Code](#install-in-t3-code)

This compiled candidate supports **Apple Silicon Macs and Linux x64 with glibc 2.31+**. The plugin runs locally and does
not require the tensorViz VS Code extension or a separate Node.js installation.

## Requirements

- **macOS on Apple Silicon or Linux x64 with glibc 2.31 or newer**. Linux also
  needs `/usr/bin/python3` for launcher metadata, `curl`, `sha256sum` and `tar`.
  This compiled preview targets CPU capture. Windows, Linux ARM64, Intel Macs
  and musl are unsupported; CUDA capture remains unverified.
- **CPython 3.12** with compatible PyTorch and your model's dependencies, or
  tensorViz's managed Python setup when no compatible environment is available.
- A local PyTorch model project and **Codex, Claude Code, Cursor, or T3 Code with its Codex provider** with plugins
  enabled. Your coding client's account and tool permissions still apply;
  tensorViz does not require its own account or provider API key.
- Internet access for the initial runtime download and any approved Python setup.

The launcher selects the **MCP execution host** with `uname`, not the desktop
showing your client. Linux needs a catalog that actually pins a Linux asset;
installed 0.3.104 remains Darwin-only until a new runtime is published. This source
change does not update existing releases. Remote browser links require forwarding
from that host; SSH environment variables do not select a desktop runtime.

## Download

**Codex and Claude Code users can install directly** with the commands below.
A complete catalog ZIP is also available for local marketplace installation.

For a manual download, open the
[Releases page](https://github.com/tensorviz-org/tensorviz-plugins/releases),
choose a version, expand **Assets**, and download the ZIP for your app.
The links below are for **[preview 0.1.44](https://github.com/tensorviz-org/tensorviz-plugins/releases/tag/v0.1.44)**:

| Client | Plugin download | Installation |
| --- | --- | --- |
| Codex | [tensorviz-catalog-0.1.44.zip](https://github.com/tensorviz-org/tensorviz-plugins/releases/download/v0.1.44/tensorviz-catalog-0.1.44.zip) | [Codex instructions](#install-in-codex) |
| Claude Code | [tensorviz-catalog-0.1.44.zip](https://github.com/tensorviz-org/tensorviz-plugins/releases/download/v0.1.44/tensorviz-catalog-0.1.44.zip) | [Claude Code instructions](#install-in-claude-code) |
| Cursor | [tensorviz-cursor-0.1.44.zip](https://github.com/tensorviz-org/tensorviz-plugins/releases/download/v0.1.44/tensorviz-cursor-0.1.44.zip) | [Cursor instructions](#install-in-cursor) |

The catalog ZIP contains the local marketplaces and both client directories.
Extract it into a persistent directory, for example `~/tensorviz-catalog-0.1.44`.
The separate `tensorviz-0.1.44.zip` and Cursor ZIP contain single plugins,
not catalogs; do not pass those to `plugin marketplace add`. See
[local installation](docs/installation.md#install-from-a-local-repository).

The compiled runtime downloads automatically on first connection. You do not
need to download or unpack the separate `tensorviz-runtime-…tar.gz` release asset.
The launcher checks its pinned SHA-256 digest before use and caches the verified
archive for later connections. No source checkout, build tools, Node.js or VS Code
installation is needed to use the compiled plugin. The public distribution
repository and archives contain only the audited launcher and integration;
the core source and its Git history are excluded. Browser-delivered JavaScript remains inspectable, and
binaries can be reverse engineered. A GitHub release does not imply an official
client marketplace listing.

## Install in Codex

1. Install or update the [Codex CLI](https://developers.openai.com/codex/cli/).
   It must be available as `codex` in your terminal, including when you use the
   Codex desktop app.
2. Open a terminal on the machine where Codex executes, including the Linux
   server for an SSH session. Run these commands one at a time:

   ```sh
   codex plugin marketplace add tensorviz-org/tensorviz-plugins
   codex plugin add tensorviz@tensorviz-standalone
   ```

   The first command adds tensorViz's plugin catalog; the second installs tensorViz.

3. Check the installation:

   ```sh
   codex plugin list --marketplace tensorviz-standalone
   ```

   Confirm that tensorViz is installed and enabled.
4. Open your model project in Codex and start a **new chat**. If the plugin does
   not appear, restart Codex and check its plugin settings.
5. Use the [example prompt below](#use-tensorviz) and complete any permission or
   environment setup prompts.

Installation is for your Codex user profile, so you can use the plugin across
projects. Keep only one tensorViz connection enabled in that profile. If you
previously installed the extension companion or a manual tensorViz MCP server,
disable that connection before using this plugin. See the
[official Codex marketplace guide](https://developers.openai.com/plugins/build/plugins).

## Install in Claude Code

Install or update [Claude Code](https://code.claude.com/docs/en/setup) first.
Open a terminal on the MCP execution host, then run:

```sh
claude plugin marketplace add tensorviz-org/tensorviz-plugins
claude plugin install tensorviz@tensorviz-standalone --scope user
```

The first command adds tensorViz's plugin catalog; the second installs it for
your user account, so it is available across projects.

Alternatively, inside an interactive Claude Code session, run:

```text
/plugin marketplace add tensorviz-org/tensorviz-plugins
/plugin install tensorviz@tensorviz-standalone
```

Choose **user** scope if prompted to make the plugin available across projects.
Start a **new Claude Code session** in your model project, then use the
[example prompt below](#use-tensorviz). Use `/plugin` to check that tensorViz is
installed and enabled. Disable any older tensorViz plugin or manual MCP connection
so only one host is active. These instructions cover Claude Code; they do not
establish Claude Cowork support. See
[Claude Code's plugin guide](https://code.claude.com/docs/en/discover-plugins).

## Install in Cursor

Use the **Cursor ZIP** linked above. Its launcher configuration is different
from the Codex/Claude package. Install or update [Cursor](https://cursor.com/downloads)
first.

1. Download `tensorviz-cursor-0.1.44.zip` to your Downloads folder.
2. Keep the ZIP file in Downloads. Open the macOS **Terminal** app and, for a
   fresh installation, run:

   ```sh
   mkdir -p "$HOME/.cursor/plugins/local/tensorviz"
   unzip "$HOME/Downloads/tensorviz-cursor-0.1.44.zip" \
     -d "$HOME/.cursor/plugins/local/tensorviz"
   ```

   The extracted folder should directly contain `plugin.json`,
   `.cursor-plugin/plugin.json`, `scripts/`, and `skills/`. If you already have
   tensorViz installed, follow the [update instructions](docs/installation.md#update-or-remove)
   instead of extracting over its existing files.
   These commands create Cursor's local plugin folder and unpack tensorViz into
   it. If you downloaded a different version, replace `0.1.44` in the command
   with that version.
3. Restart Cursor or press **Command + Shift + P** and run
   **Developer: Reload Window** from the Command Palette.
4. Open **Customize** and check for tensorViz's `model-workflow` skill and MCP
   server. Local plugin imports must be allowed by your account or organization;
   a marketplace installation with the same name takes precedence over a local copy.
5. Open your model project, start a **new Agent chat**, and use the
   [example prompt below](#use-tensorviz).

Cursor's [local plugin guide](https://cursor.com/docs/plugins#test-plugins-locally)
describes this import flow. Graph display can use a local browser when the client
cannot display the Model graph panel. Check [support](SUPPORT.md) for this
preview's compatibility limits.

## Install in T3 Code

Preview 0.3.20 adds the interactive **Model graph** panel to T3's Codex chats,
including the Mac desktop app. Install tensorViz with the [Codex commands above](#install-in-codex)
in the Codex profile selected under **T3 Settings → Providers → Codex**. Then
start a new Codex thread or choose **Restart agent session**.

Ask: “Use tensorViz to capture my PyTorch model with its saved inputs, then call
open_graph_panel to show the interactive Model graph in this chat.” Include the
model file and class if the project has more than one model.

The panel displays inline, expands to fullscreen, and shares your selected layer
with the agent. Reading captured details does not execute the model; Refresh
retains the normal approval flow. Desktop acceptance used
**T3 0.0.46-nightly.20261012.3035**. Stable **0.0.45** supports capture and inspection
with a local browser graph, but did not render the embedded panel in testing.
See the [T3 setup and troubleshooting guide](BUILD.md#t3-code), including custom
Codex profiles and agent-session lifetime.

## Included integration

The plugin ships the `model-workflow` skill and a local MCP server with **29
tools**: 25 agent tools and four tools reserved for the Model graph app. See the
[tool inventory and integration boundaries](BUILD.md#tools-and-integration-boundaries).
There are no separate bundled slash commands. T3 uses the Codex integration;
Claude Cowork and other clients have not been verified for this release.

## Use tensorViz

After installation, start a new chat in the folder containing your model and ask:

> Use tensorViz to open my PyTorch model, capture its saved example input, and
> explain the tensor shapes. Show the graph, then refresh it after my saved edit.

For a project with multiple models, include the file, class, and known input:

> Use tensorViz to open `models/mlp.py`, class `MLP`, with a CPU float32 input of
> shape `[1, 16]`. Show the graph and explain the input and output shape of each layer.

Replace that example file, class, and shape with your model's actual values.

On first use:

1. Review tensorViz's permission prompt. Capture executes your local model code;
   the disclosed permission also covers supported environment setup and dependency
   repair across projects. Your client's own tool permissions still apply.
2. Select a compatible **Python 3.12** environment if asked. If none is available,
   supported managed setup can provision Python and dependencies under your
   tensorViz permission. Model-specific packages and assets may still need setup.
3. Confirm any missing constructor arguments or example inputs. An existing
   `tensorviz.toml` recipe is reused; otherwise setup can save a recipe for later.
4. Wait for capture to finish. Ask for the **Model graph** panel when supported,
   or open the local browser link returned by tensorViz. A source preview alone
   does not contain measured tensor shapes.

**You'll know it worked when** the agent reports a successful capture and shows
your model graph with measured input and output shapes on its layers.

Then try:

- “Explain the layer I selected and its input/output tensor shapes.”
- “I saved a change to the model. Refresh the graph using the same example inputs.”
- “Use the capture evidence to help me debug this tensor shape mismatch.”

A capture describes the chosen input and execution, not every possible path.
Keep private graph links out of public issues and messages.

See [troubleshooting, updates, and removal](docs/installation.md),
[runtime installation details](BUILD.md), [privacy](PRIVACY.md), [terms](TERMS.md),
and [support](SUPPORT.md). The integration's license does not establish licensing
for third-party components inside the compiled runtime.

## External services and local data

The launcher downloads the compiled runtime from GitHub Releases. Approved Python
setup can contact Python/package providers to install the selected environment and
dependencies. Imported model code may contact its own services. The bundled tldraw
production-trial renderer can send license-usage information to tldraw; this does
not include canvas content. Graph evidence returned through MCP enters the coding
client and may enter its model-provider conversation. TensorViz does not operate a
cloud ingestion service. Recipes, captures, runtime caches and permission records
remain on the user's machine until removed. See [privacy](PRIVACY.md) for details.
