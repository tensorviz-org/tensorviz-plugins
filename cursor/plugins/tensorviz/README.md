# tensorViz for coding agents

Explore a local PyTorch model as a graph, inspect measured tensor shapes, and
refresh the graph after a source edit. The plugin runs its own local host. VS Code
and a separate Node.js installation are not required by the compiled distribution.

## Availability

This repository contains the integration only. Check the
[versioned releases](https://github.com/tensorviz-org/tensorviz-plugins/releases)
for published runtime downloads. Private candidates may refer to a URL that is
not live yet. Directory approval is separate from a repository release.
The first target is macOS Apple Silicon with CPython 3.12.
Other platforms and Python versions require separate builds and acceptance tests.

The plugin contains a readable launcher, client manifests, a workflow skill and
a pinned runtime URL/checksum. On first connection the launcher downloads the
compiled runtime, verifies it, then caches its archive. Later connections verify
and reuse the archive. The core source is not included. Browser-delivered
JavaScript remains inspectable, and binaries can be reverse engineered.

## Try it

Install the matching plugin through your coding client's supported plugin flow,
then start a new chat in your model project:

> Use tensorViz to open my PyTorch model, capture its saved example input, and
> explain the tensor shapes. Show the graph, then refresh it after my saved edit.

Provide the model file and class if the model is ambiguous. Your client can request
installation or tool consent. TensorViz also requests its disclosed persistent
permission on first use when installation has not collected it.

Capture uses the selected compatible project Python environment. If none is
available, supported managed setup can provision Python and dependencies under
your TensorViz permission. Project-specific packages and model assets may still
need setup. A capture describes that input and execution, not every possible path.

See [installation](BUILD.md), [privacy](PRIVACY.md), [terms](TERMS.md) and
[support](SUPPORT.md). The integration's license does not establish licensing for
third-party components inside the compiled runtime.

## External services and local data

The launcher downloads the compiled runtime from GitHub Releases. Approved Python
setup can contact Python/package providers to install the selected environment and
dependencies. Imported model code may contact its own services. The bundled tldraw
production-trial renderer can send license-usage information to tldraw; this does
not include canvas content. Graph evidence returned through MCP enters the coding
client and may enter its model-provider conversation. TensorViz does not operate a
cloud ingestion service. Recipes, captures, runtime caches and permission records
remain on the user's machine until removed. See [privacy](PRIVACY.md) for details.
