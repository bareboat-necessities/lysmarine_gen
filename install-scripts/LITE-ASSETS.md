# LITE asset policy

This repository targets the Raspberry Pi OS trixie LITE build on arm64.
Only assets referenced by install scripts should live under `install-scripts/**/files/`.
Unused assets are removed to keep the image footprint small and the build flow clear.
