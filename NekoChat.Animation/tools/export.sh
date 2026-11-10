#!/bin/zsh
set -euo pipefail
ROOT="${0:A:h:h:h}"
BASE="$ROOT/NekoChat.Animation"
MAC="${1:?Pass an existing macOS Git checkout}"
REV=ef9fe89f1f78698453ed13d3cfba4181fc326537
SNAP="$ROOT/build/animation-native-source"
mkdir -p "$SNAP" "$ROOT/build/animation-tools"
git -C "$MAC" archive "$REV" Sources/GroqVoiceInput Resources/DesktopPet Examples/CatAppearance LICENSE | tar -x -C "$SNAP"
swiftc -O -swift-version 5 -D DESKTOP_PET_TESTS -framework AppKit \
 "$SNAP/Sources/GroqVoiceInput/DesktopPetModel.swift" \
 "$SNAP/Sources/GroqVoiceInput/DesktopPetLift.swift" \
 "$SNAP/Sources/GroqVoiceInput/DesktopPetGroomingPalm.swift" \
 "$SNAP/Sources/GroqVoiceInput/DesktopPetView.swift" \
 "$SNAP/Sources/GroqVoiceInput/CatAppearance.swift" \
 "$SNAP/Sources/GroqVoiceInput/CatAppearanceArtwork.swift" \
 "$SNAP/Sources/GroqVoiceInput/CatAnatomy.swift" \
 "$BASE/tools/ExportAnimation.swift" -o "$ROOT/build/animation-tools/export"
"$ROOT/build/animation-tools/export" "$SNAP" "$BASE/Assets"
python3 - "$BASE" "$SNAP" "$REV" <<'PYMANIFEST'
import hashlib,json,sys
from pathlib import Path
base,snapshot,revision=Path(sys.argv[1]),Path(sys.argv[2]),sys.argv[3]
manifest=base/'Assets/manifest.json';data=json.loads(manifest.read_text())
data['sourceCommit']=revision
data['rendererSHA256']=hashlib.sha256((snapshot/'Sources/GroqVoiceInput/CatAppearanceArtwork.swift').read_bytes()).hexdigest()
manifest.write_text(json.dumps(data,ensure_ascii=False,indent=2)+'\n')
PYMANIFEST
cp "$SNAP/LICENSE" "$BASE/Assets/LICENSE"
cp "$SNAP/Resources/DesktopPet/README.md" "$BASE/Assets/SOURCE-ARTWORK.md"
