File: README_file-permissions.txt
2026-Jan-17 Jim Fischer <fischerjd@missouri.edu>
© 2026 James D. Fischer
---------------------------------------------------------------------------

The file access permissions on folder ~/.ssh/ and its subdirectories must
be 0700 (drwx------).  You can use the find(1) program to find folder
~/.ssh/ and all its subfolders, and combine that with the chmod(1) program
to change the mode bits (the access permissions) on each of those folders:

```bash
    $ find ~/.ssh/ -type d -exec chmod 0700 "{}" \;
```

The permissions on the public key files for your SSH identities should be
set to 0644 (-rw-r--r--).  The permissions on all other files within folder
~/.ssh/ should be set to 0600 (-rw-------).

If the public key files have a file name extenion of '.pub', you can use
the commands shown below to quickly and correctly set the access permis-
sions of all files within folder ~/.ssh/:

```bash
    # For each file in ~/.ssh/ where the file name DOES NOT end in '.pub'
    # (i.e., for each file in ~/.ssh/ that IS NOT a public key file), set
    # the file's access permissions to 0600 (-rw-------).
    $ find ~/.ssh/ -type f ! -name '*.pub' -exec chmod 0600 "{}" \;

    # For each file in ~/.ssh/ whose file name DOES end in '.pub', set the
    # file's access permissions to 0644 (-rw-r--r--).
    $ find ~/.ssh/ -type f -name '*.pub' -exec chmod 0644 "{}" \;

    # Verify the access permissions on folder ~/.ssh/ and its contents:
    $ find ~/.ssh/ -exec ls -ld "{}" \;
    drwx------. 1 fischerjd fischerjd 288 Jan 17 19:40 /home/fischerjd/.ssh/
    -rw-------. 1 fischerjd fischerjd 9810 Jan 16 13:01 /home/fischerjd/.ssh/config
    -rw-------. 1 fischerjd fischerjd 208 Jan  4 16:22 /home/fischerjd/.ssh/authorized_keys
    -rw-------. 1 fischerjd fischerjd 37967 Jan 17 19:02 /home/fischerjd/.ssh/known_hosts
    -rw-------. 1 fischerjd fischerjd 464 Feb  7  2025 /home/fischerjd/.ssh/id_ed25519
    -rw-r--r--. 1 fischerjd fischerjd 104 Feb  7  2025 /home/fischerjd/.ssh/id_ed25519.pub
```
# vim: set syn=tutorial :

