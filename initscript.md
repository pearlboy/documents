# Android INIT Script
### Box with 192.168.1.55 as IP on it

## YOUR Procedure
```shell
1. adb connect [box IP address]
2. adb root
3. adb remount (remount /system partition as RW)
4. adb push heroapp.sh /system/bin/    (you can push different version of heroapp.sh for PC to box)

# I added shell before chmod because adb chmod is not found on mine
5. adb chmod a+x /system/bin/heroapp.sh

6. adb shell sync
7. adb shell reboot
```

## WHAT I DID

Connect to box
```shell
$ adb connect 192.168.1.55:5555
* daemon not running; starting now at tcp:5037
* daemon started successfully
connected to 192.168.1.55:5555
```

```shell
$ adb root
adbd is already running as root
```

```shell
$ adb remount
remount succeeded
```

Script in ```heroappslog.sh```
```shell
while :
do
	echo $(date) >> /data/local/myheroappslog
	sleep 1
done
```


```shell
$ adb push heroappslog.sh /system/bin/
heroappslog.sh: 1 file pushed. 0.0 MB/s (65 bytes in 0.020s)
```

```shell
$ adb shell chmod a+x /system/bin/heroappslog.sh
```


```shell
$ adb shell sync
```


```shell
$ adb shell reboot
```

Check if init started, but not yet started
```shell
$ adb shell cat /data/local/myheroappslog
/system/bin/sh: cat: /data/local/myheroappslog: No such file or directory
```
