#!/bin/sh
clear

export QT_QPA_PLATFORM=wayland-egl
export WLR_DRM_DEVICES=$(readlink -f /dev/dri/by-path/pci-0000\:00\:02.0-card)  #use intel iGPU
#export WLR_RENDERER=vulkan
export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
export QT_WAYLAND_FORCE_DPI=physical

export SDL_VIDEODRIVER=wayland
export ECORE_EVAS_ENGINE=wayland_egl
export ELM_ENGINE=wayland_egl

export XDG_CURRENT_DESKTOP=sway
    
export GSK_RENDERER=ngl # for swayosd to start faster(in my case)
# avoid loading nvidia modules ( ref arch linux wayland wiki )
#export __EGL_VENDOR_LIBRARY_FILENAMES=/usr/share/glvnd/egl_vendor.d/50_mesa.json

export GTK_USE_PORTAL=1 # for terminal file chooser

echo "Starting sway..."
if [ -n  "$SWAYSOCK" ]; then
    echo "SwayWM is already running."
else dbus-run-session sway --unsupported-gpu > /tmp/${UID}-sway.log 2>&1
fi
