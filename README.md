# floruntime/tap

Homebrew formulae for [Flo](https://github.com/floruntime/flo).

```bash
brew tap floruntime/tap
brew install flo
```

Start a server and try it:

```bash
flo server start
flo kv set hello world
flo kv get hello
```

Clients connect on port `9000`; point the CLI at another server with
`FLO_ENDPOINT=host:9000`. The dashboard listens on `http://127.0.0.1:9002`.

The formula installs the prebuilt binaries attached to each
[Flo release](https://github.com/floruntime/flo/releases), and the release
workflow updates it when a release is published.
