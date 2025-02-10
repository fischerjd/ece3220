README

This Git repository provides two methods for configuring your SSH setup: a
Bash script and a "how to" guide.

* (Bash Script) The Bash script fully automates the SSH configuration
  process for you.  The bash script is named 'ssh-setup' and it resides in
  this Git repository's 'bin' folder. Assuming this Git repository is
  stored in the folder path '~/git/ece3220/', you would use the command
  line shown below to invoke the 'ssh-setup' script:

    $ ~/git/ece3220/bin/ssh-setup

  [Note 1. On the command line shown above, the dollar sign '$' is the Bash
  shell's command prompt. Do not type the dollar sign when entering the
  command line shown above. --end note]

  [Note 2. If you use the Bash script method, you do not need to read the
  remainder of this file, and you do not need to read the other text files
  in this Git repository's 'ssh' folder. --end note]

* (How-To Guide) The how-to guide is provided in these files, which are
  found in this Git repository's 'ssh' folder:
    * 01-README.txt
    * 01-Create-your-SSH-key-files.txt
    * 02-Create-your-authorized_keys-file.txt
    * 03-Create-your-SSH-configuration-file.txt
  These files provide step-by-step instructions that describe the commands
  you should invoke to manually create your SSH configuration.  The
  instructions provided in these files should be performed in the same
  order as shown above.

===========================================================================
HINTS FOR THE HOW-TO GUIDE
---------------------------------------------------------------------------

Open two command shell windows.  Use one window to display the contents of
the text file you are currently working with.  Use the second window to
type and execute the command lines that are shown in the text files.

---------------------------------------------------------------------------

The program named `less' is a pager program.  You can use `less' to browse
the contents of the text files listed above, e.g.,

    $ less 01-Create-your-SSH-key-files.txt

If you want the `less' pager to display line numbers when viewing a file's
contents, add the optional flag `-N' when invoking less on the command
line:

    $ less -N 01-Create-your-SSH-key-files.txt

Alternatively, when the `less' pager is running, you can toggle line
numbers on/off by typing -N and then pressing the ENTER (RETURN) key.

When viewing the contents of a text file with the `less' pager program:

    * Use the keyboard's arrow keys and Page Up / Page Down keys to scroll
      up and down through the file.
      
    * Press the 'q' key (q=quit) to quit/exit the less program and return
      to the command prompt.

    * Press the 'h' key (h=help) or 'H' to display the commands that are
      available to you when using the `less' pager program.

===========================================================================
Copyright 2025 James D. Fischer

