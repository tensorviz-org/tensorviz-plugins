# Support and compatibility

This compiled candidate targets macOS Apple Silicon or Linux x64 (glibc >=2.31)
and CPython 3.12 CPU capture. Linux requires a catalog pinning a Linux asset;
existing v0.3.104 snapshots remain Darwin-only.
It does not require VS Code or Node.js. Explicitly selected incompatible Python
versions produce an error; TensorViz does not silently replace that environment.
Windows, Linux ARM64, Intel Macs and musl are unsupported. CUDA and other Python
ABIs remain unverified. Runtime selection follows the MCP execution host, not the
client desktop. Local Linux evidence does not establish real SSH networking,
Cursor/Claude Linux acceptance or new native Darwin acceptance.

The integration works with clients that support its local MCP transport and
plugin format. Directory publication is distinct from local installation, capture
and rendering. No official marketplace acceptance is claimed for this candidate.

When reporting a problem, include the integration version, OS/client version,
whether it failed during download, startup or capture, and a small synthetic
model. Do not share credentials, private viewer links, model secrets or unredacted
environment dumps. Use
[the integration repository's issues](https://github.com/tensorviz-org/tensorviz-plugins/issues)
for public, non-sensitive bug reports.
