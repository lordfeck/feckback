# FECKBACK
A specifically-tailored backup script collection. Works well for my situation. It may also work well for yours!

*Licence* 3BSD. Not GPL because I don't want contributions, but you're free to it!

# Requirements
* Bash
* ssh with keys installed
* tar
* rsync (optional)

## Configuration
Run setup.sh.

Edit `~/.config/feckback.conf` to suit your environment.

Edit `~/.config/feckback.exclude` specify any directories for exclusion. 

**Note:** For feckback.exclude, all directories are relative to the root of the backupDir.
This isn't pattern matched, so you'll have to specify each subdirectory for exclusion manually.

### Configuration - multiple jobs
It's possible you may want to have more than one backup job on your system.

In that case, run `./setup.sh <newjob>` to install a new job with that name..

Then, edit `~/.config/feckback.d/<newjob>.conf` and `<newjob>.exclude` for your job.

Call `./feckback.sh <jobname>` and the config and exclude files for that job will be read from `feckback.d`. Then the job will begin.

## Usage
Run `./feckback.sh`. If your hosts are configured correctly, this should work.

## Auxilary Scripts
### syncnas.sh 
It's always wise to backup your backups. So, I wrote this script because by Synology NAS couldn't write any data to USB without corrupting the filesystem. 

Syncnas should be run on an external headless device such as a RPi. It will sync the contents of the network drive with portable storage, assuming you've ssh access and rsync running.

It uses nohup to continue running after logout.

## Future plans
`backupwin.cmd` - An equivalent in Windows Batch (*not* Bash) to backup and copy Windows files.
