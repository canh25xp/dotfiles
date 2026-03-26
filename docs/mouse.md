# Mouse

## Disable mouse accel

<!-- TODO -->

/etc/X11/xorg.conf.d/50-mouse-accel.conf

Section "InputClass"
    Identifier "My Mouse"
    MatchIsPointer "on"
    Driver "libinput"
    Option "AccelProfile" "flat"
EndSection
