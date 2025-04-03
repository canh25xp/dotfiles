# odin4

> Communicate with Samsung devices in Odin mode (also called download mode)
> Reboot a connected Android device or emulator.
> More information: <https://mobilerndhub.sec.samsung.net/hub/site/odin>.
>
> To enter Download mode:
>
> 1. Power off
> 2. Volume up + volume down key press
> 3. Connect to PC with USB cable
> 4. Press volume up key skip Warning message

- Check connected device

`odin4 -l`

- Flash all devices

`odin4 -a {{ALL_XXX.tar.md5}}`

`odin4 -a {{AP_XXXX.tar.md5}} -b {{BL_XXXX.tar.md5}} -c {{CP_XXXX.tar.md5}} -s {{CSC_XXXX.tar.md5}} -u {{USERDATA_XXX.md5}}`

- Flash one device

`odin4 -a {{AP_XXXX.tar.md5}} -b {{BL_XXXX.tar.md5}} -c {{CP_XXXX.tar.md5}} -s {{CSC_XXXX.tar.md5}} -u {{USERDATA_XXX.md5}} -d {{COMXX}}`
