# BFG-Repo-Cleaner-Helper-Script (Batch File)

This clumsy batch file works with the [BFG Repo-Cleaner by rtyley](https://github.com/rtyley/bfg-repo-cleaner) which doesn't need help -- it's awesome.

Read about it [here](https://rtyley.github.io/bfg-repo-cleaner/) and grab a copy.

`clean.bat` walks you through removing unwanted files, folders, or text before running BFG.  It **will** replace text, but it won't delete files or folders.  Instead it removes the cached copy and adds it to gitignore.

Watch [an awkward demonstration of using the script](https://www.youtube.com/watch?v=p4HPGFNS77Q)

Or get [the python version](https://github.com/yoshimi777/BFG-Helper-Python)

***

If you accidentally pushed private data (password, key, token, etc.), consider it compromised.  Your first step was to **immediately** change the leaked password and/or generate a new token or key.

You can remove the offending data, file, or folder, but the debacle lives on in your repo's history.  That's where [BFG Repo-Cleaner](https://rtyley.github.io/bfg-repo-cleaner/) comes in.  *You don't need this script*, but you should probably have a copy of BFG handy.  It's a faster, simpler alternative to git's filter-branch.  BFG can also remove large files, but this script dumbs it down, with just three options.

>The script was created for demonstration purposes, to show how great BFG Repo-Cleaner is, but I needed to filter out the political message.  I don't disagree, just couldn't have that on my screen.  Then I got carried away.

## What this script does

By default, BFG protects the data in your last commit, cleaning the history, not the current state of things, and that's as it should be.  BFG assumes you've reformed, made your changes, but this script has less faith in you.

Instead, it holds your hand and walks you through making three main changes:

* replacing text in a file or files, like a password

* removing the history of a file or files

* removing the history of a folder or folders

Aside from replacing text, your data isn't deleted from the repository, just removed from the index and added to gitignore.  If you were to use git filter-branch, that would anniliate the offending file.

Only after these changes are made is a mirror cloned, and BFG does its thing.
This script makes a backup of your mirror, but if you run it again, **the backup will be overwritten**.  If you run it again, change the name.

Your remote repository on GitHub and local copy are clean after the last step, a forced pull rebase, but any stashed commits will be gone.

If you share a repo, use extra caution.  Not only will people be mad if you didn't give them a sufficiant head's up, but a merge could reintroduce the dirty data.  So, as the creator of the BFG repo cleaner suggests, it's probably best if everyone ditches their local copies and clones fresh clean ones.

## If you still wanted to use this

Be aware that it will make the changes.  Re-read the last two paragraphs.  Tested only on Win10, with bfg version 1.12.16.

Make sure Java is installed and in your environment variable **path**.  On Windows 10, that's something like, C:\Program Files\Java\jdk1.8.0_112\bin, depending on your version. Add it to the path. Again, on Windows, that setting can be found in Control Panel > All Control Panel Items > System > Advanced System Settings > Environment Variables...

This also uses sed.exe and grep.exe, which should be in the C:\Program Files\Git\usr\bin.

Open a command prompt and try typing java.  If it doesn't give you Usage, it's not in your **path**.  Same with sed and grep.  Check again, that it's in both your user path and system path, and *reopen* a command prompt window.  It should work.

Clone or download this repo (or just the batch file, downloading your own copy of BFG and putting them both in a folder) and place folder next door to the one you want to clean.  Directory tree should look something like this:

```crystal
Documents/
        BunchofRepos/
            Repo1/
            Repo2clean/
                .gitignore
                Folder/
                    somefile.txt
                    DirtyDirectory/
                readme.md
                dirtyfile.txt
            BFG-Helper/
                clean.bat
                bfg.jar
```

The point is that you definitely don't want to place it *in* the dirty repo, but beside it.  The script assumes that it shares a parent directory with what it's trying to clean, and that the root directory of Repo2clean is Repo2clean, and not a subdirectory.

When it asks for the Repo name (Repo2clean in our example), it assumes that the name is the same on GitHub and your local copy.  When it asks for a file path, it wants it in relation to root directory of said repo.  To remove Repo2clean's Dirtydirectory/ inside of Folder/, tell it, `folder/dirtydirectory` (leave out forward slash, it's added for you).  Remove just a file in the root: `dirtyfile.txt`.  If you want to clean somefile.txt in the directory folder/, you tell it `folder/somefile.txt`.  This is not how BFG works, by the way, but it's how git understands what specific file or folder we're looking for when removing the cached copy.

***

Direct download of BFG version I used: [here](http://repo1.maven.org/maven2/com/madgag/bfg/1.12.16/bfg-1.12.16.jar)

It's not a dangerous file, but since it's a jar, Chrome alerts on it.  Rename it bfg.jar, and place it in your new BFG-Helper folder.

If you do use this, please use it with caution, particularly if you're cleaning a repo that others work on, too.  You'll have a pre-clean (prior to running script) backup, and another made right before running BFG.  Right now, they're both overwritten if you run it again on the same repo.  Rename the backups if you want to keep them. With a mirrored clone, you can recover the entire file tree and history, dirt and all.