# Find where a folder is open

The program `lsof` can be used to get a list of all the files opened by processes.

To search for a specific mount point use `grep`:

```bash
lsfo | grep '/mnt/DISK'
```

This can be usefull when trying to unmount a disk and it shows as busy.
With this it is possible to find which programs are using the disk and kill
them.
