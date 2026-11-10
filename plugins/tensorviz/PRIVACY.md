# Privacy and data handling

TensorViz's agent plugin runs a local MCP host and Python workers. Discovery reads
model source. Capturing executes the selected model with the selected environment
and example inputs. Approved setup can write recipes and download Python runtimes
or packages from their providers. Imported model code and dependencies can have
their own filesystem and network behavior.

Graph evidence, source excerpts, paths and errors returned through MCP are visible
to the coding client and can enter its model-provider conversation. The client's
privacy, retention and organization policies apply. Do not provide sensitive models
or data unless those policies permit it.

The plugin does not operate a TensorViz cloud ingestion service, and its browser
and panel builds exclude TensorViz's hosted authentication and analytics modules.
The browser viewer uses a local connection. Keep private viewer links private.

Nothing reaches tensorviz.dev unless you click **Publish** in the graph. Then the
plugin signs you in with Google through tensorviz.dev and uploads that graph file,
including its detached capture, to your account as private. The website records your
Google account's name and photo as its author; tensorviz.dev's own privacy policy applies
to it. The plugin keeps only a refresh token, in a private `website/session.json` in its
data folder. Run `scripts/launch.sh --sign-out` to delete it.
The tldraw renderer has separate license-validation behavior; trial licenses can
send license-usage information to tldraw. See
[tldraw's licensing and data collection documentation](https://tldraw.dev/community/license).

Model recipes and captures, local session resources, runtime installations and
permission records can remain on disk. Removing the plugin does not delete model
source, recipes or Python environments. Run the installed plugin's
`scripts/launch.sh --revoke-permission` to revoke TensorViz permission, or disable
the plugin in your coding client. See [installation and removal](BUILD.md).

Do not post private model code, credentials, full environment dumps or private
viewer URLs in public issues. See [SUPPORT.md](SUPPORT.md) for reporting problems.
