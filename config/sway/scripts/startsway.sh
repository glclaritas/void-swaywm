#!/bin/bash
clear

export WLR_BACKENDS="libinput,drm" # comma-separated list of backends to use (available backends:libinput, drm, wayland, x11, headless)
export WLR_DRM_DEVICES=/dev/dri/card0
export WLR_RENDER_DRM_DEVICE=/dev/dri/renderD128
export WLR_RENDERER=gles2 # vulkan, gles2, pixman

export QT_QPA_PLATFORM="wayland;wayland-egl,xcb"
export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
export QT_WAYLAND_FORCE_DPI=physical

export SDL_VIDEODRIVER=wayland,x11
export ECORE_EVAS_ENGINE=wayland_egl
export ELM_ENGINE=wayland_egl

export XDG_CURRENT_DESKTOP=sway
    
export GSK_RENDERER=gl # for gtk4 apps to start faster(in my case)
# avoid loading nvidia modules ( ref arch linux wayland wiki )
#export __EGL_VENDOR_LIBRARY_FILENAMES=/usr/share/glvnd/egl_vendor.d/50_mesa.json
#export VK_DRIVER_FILES=/usr/share/vulkan/icd.d/intel_icd.x86_64.json

export GTK_USE_PORTAL=1 # for terminal file chooser

echo "Starting sway..."
if [ -n  "$SWAYSOCK" ]; then
    echo "SwayWM is already running."
else dbus-run-session sway > /tmp/${UID}-sway.log 2>&1
fi
