#!/bin/bash
# Helium browser launcher used by the Super+W binding.
# Extra arguments are passed through to Helium.
exec helium-browser --ozone-platform-hint=wayland --force-device-scale-factor=1.3 --default-zoom-level=1.05 \
  --disable-background-networking --disable-component-update --no-first-run \
  --disable-search-engine-choice-screen \
  --disable-features=ChromeWhatsNewUI,TranslateUI,MediaRouter,OptimizationGuideModelDownloading \
  "$@"
