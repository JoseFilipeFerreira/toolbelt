# Add Offset to Photo Timestamps

Add offset to EXIF timestamps and Date Modified in a batch of photos.
This is useful if, for example, photos are taken from different cameras with
different internal clocks and it is needed to sync them.

## Offset on EXIF Timestamp
Apply offset to EXIF time with `exiftool`:
```bash
# add offset
exiftool -v "-AllDates+=Y:M:D H:M:S" *
# subtract offset
exiftool -v "-AllDates-=Y:M:D H:M:S" *
```

## Sync Date Modified with EXIF
Sync Date Modified of File with EXIF time with `exiftool`:
```bash
 exiftool -v '-FileModifyDate<DateTimeOriginal' *
```

## Check
Check if modifications where successful
```bash
exiftool FILE FILE_original
```
If modifications where successful
```bash
rm *_original
```
