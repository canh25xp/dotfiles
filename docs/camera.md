# Camera

First check for camera device

```sh
ls /dev/video*
```

```
/dev/video0
/dev/video1
```

Alternatively

```sh
sudo apt install v4l-utils
v4l2-ctl --list-devices
```
```
Integrated Camera: Integrated C (usb-0000:00:14.0-5):
        /dev/video0
        /dev/video1
        /dev/media0
```

Test camera

```sh
ffplay /dev/video0  # preview stream from the first camera device
ffmpeg -f v4l2 -i /dev/video1 -frames:v 1 photo.jpg  # capture a still image from the second device
```
