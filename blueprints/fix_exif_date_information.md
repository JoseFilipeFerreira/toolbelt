# Fix EXIF date information

Guide on how to fix EXIF date shenanigans in a batch of photos. Surprisingly, this
is extremely hard and becomes even harder if there are Timezones in the mix.

This is useful if, for example, photos are taken from different cameras with
different internal clocks and it is needed to sync them.


## Fix EXIF timezones

1. Find two pictures that were taken at the same time with
diferent cameras. Lets call the picture `A` and picture `B`.

2. run the following command, compare `Date/Time Original` and find wich one has the wrong Time zone:
```bash
exiftool A B | grep -E '(File)|(Date)'
```

3. Change timezone off the camera (changing the wildcard to match the wrong camera):
```bash
exiftool -v "-EXIF:OffsetTime*=+1:00" *
```

4. Sync file modify date with exif date (changing the wildcard to match the wrong camera):
```bash
 exiftool -v '-FileModifyDate<DateTimeOriginal' *
```

## Fix EXIF timestamps

1. Find two pictures that were taken at the same time with
diferent cameras. Lets call the picture `A` and picture `B`.

2. run the following command, compare `Date/Time Original` and find the offset betweeen them:
```bash
exiftool A B | grep -E '(File)|(Date)'
```

3. Apply offset to all EXIF Dates:
```bash
# add offset
exiftool -v "-AllDates+=Y:M:D H:M:S" *
# subtract offset
exiftool -v "-AllDates-=Y:M:D H:M:S" *
```

4. Sync file modify date with exif date (changing the wildcard to match the wrong camera):
```bash
 exiftool -v '-FileModifyDate<DateTimeOriginal' *
```

5. If modifications where successful remove original
```bash
rm *_original
```
