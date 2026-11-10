# Native cat animation for Windows voice input

This is an independent copy of the owner-approved nine-coat animation library from the original Windows repository at `5a32eb7`. The voice app consumes it through `Neighbor.Windows`; no classroom app is required. The assembly remains `NekoChat.Animation.dll` to preserve the installer payload and existing behavior.

The library targets net48 and net10.0. Assets retain their original frame timing, manifest, artwork provenance and licenses. Source renderer provenance is recorded in `Assets/SOURCE-ARTWORK.md` and `Assets/manifest.json`; MIT and dependency notices remain under `Assets/`.

From the repository root with .NET 10:

```sh
dotnet run --project NekoChat.Animation.Tests -c Release -- NekoChat.Animation/Assets/manifest.json
```

Windows builds and offline/UI tests run with `scripts/build.ps1`. Physical Windows mouse, focus and DPI acceptance remain separate from animation asset tests.

Regeneration requires macOS, Swift and the pinned macOS source checkout:

```sh
zsh NekoChat.Animation/tools/export.sh /path/to/macos-checkout
```

The original classroom integration and its QA tools remain in the source repository. No chat, network, installer or credential implementation is included in this library.
