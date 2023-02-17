#!/bin/bash

# Where to backup to.
BACKUP_DESTINATION="/root/backups"

mkdir -p $BACKUP_DESTINATION

# Create archive filename.
now=$(date +"%Y-%m-%d_T%H%M%S")
#hostname=$(uname -n)
hostname=$(hostname -s)
archive_file="${hostname}_${now}.tar"

if [[ ! -r $1 ]]; then
    echo "Error! You must specify a file containing the list of files you want to backup."
    echo
    echo "Usage: $0 INPUTFILE"
    exit
fi

# Print start status message.
echo "### Backup started: $(date +'%Y-%m-%d %H:%M:%S')"
echo

if ! RUN_GZ=$(command -v pigz) &> /dev/null     # If can not use pigz
then
    RUN_GZ=$(command -v gzip)                   # use gzip instead
fi

while read -r line; do
    [[ $line =~ ^[[:blank:]]*# ]] && continue   # Ignore comments strting with #
    [[ $line =~ ^[[:blank:]]*$ ]] && continue   # Ignore empty lines
   
    echo "Parsing line $line" 
    shopt -s nullglob                           # Allow filename patterns which match no files to expand to a null string
    for file in $line; do
        if [[ -r $file || -d $file ]]; then     # If file exists and is readable or if directory exists
            echo "Archiving $file"
            tar rf  $BACKUP_DESTINATION/$archive_file $file 2>&1 | grep -v  "Removing leading"
        else
            echo "Ignoring $file"
        fi
    done
    echo
done < "$1"

#echo "### Archive contents"
#tar tf $BACKUP_DESTINATION/$archive_file
#echo

echo "### Compressing archive"
echo "$RUN_GZ $BACKUP_DESTINATION/$archive_file"

$RUN_GZ $BACKUP_DESTINATION/$archive_file

ls -lh $BACKUP_DESTINATION/$archive_file*

# Print end status message.
echo
echo "### Backup finished: $(date +'%Y-%m-%d %H:%M:%S')"

 
