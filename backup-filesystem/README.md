# Backup Script
This simple bash script can create tar.gz backups of filesystem paths specified in a plaintext configuration file.

## Requirements
To use this script, you will need:
- Bash shell (version 4.0 or later)
- tar and gzip/pigz command-line tools
- A plaintext configuration file specifying the paths to backup


## Usage
Create a configuration file e.g. `backup-paths.txt` and specify the filesystem paths you want to backup, one per line.
Run the script by executing `kioan-backup.sh -c backup-paths.config -d /destination/path`. The script will read the configuration file and create a timestamped tar.gz archive in the directory specified with the `-d` option.


## Configuration File Format
The configuration file `backup_paths.txt` should contain one path per line, in the following format:

```bash
/path/to/file
/path/to/directory
/path/to/pattern.??
/path/to/*.ext
```
Paths can be files or directories. They can be specified as absolute paths, or relative to the location of the script. The wildcard characters asterisk (*) or question mark (?) are also accepted.

