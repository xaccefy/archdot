#!/bin/bash
# Helium browser launcher with the performance flags from lua/keybinding.lua,
# extracted so launch-or-focus can take the whole command as one argument.
exec helium-browser --force-device-scale-factor=1.3 --default-zoom-level=1.05 \
  --disable-background-networking --disable-component-update --no-first-run \
  --disable-search-engine-choice-screen \
  --disable-features=ChromeWhatsNewUI,TranslateUI,MediaRouter,OptimizationGuideModelDownloading \
  "$@"
