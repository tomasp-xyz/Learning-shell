#!/bin/bash

log() {
  # This function sends a message to syslog and to stdout if VERBOSE is true
  local MESSAGE="$@"
  if [[ "$VERBOSE" = "true" ]]
  then
    echo "$MESSAGE"
  fi
  logger -t function_demo.sh $MESSAGE
}

backup_file() {
  # This function creates a backup of file. Returns non-zero status on err
  local FILE="$1"

  # Make sure file exists
  if [[ -f "$FILE" ]]
  then
    local BACKUP_FILE="/var/tmp/$(basename $FILE).$(date +%F-%N)"
    log "Backing up $FILE to $BACKUP_FILE"

    # Exit status of function will be the exit status of the cp command
    cp -p $FILE $BACKUP_FILE
  else
    # The file does not exist, return non 0 exit status
    return 1
  fi
}

readonly VERBOSE="true"
log "Hello!"
log "Shell is calling!"

backup_file "/etc/passwd"

# Make decision based on exit status of function
if [[ $? -eq "0" ]]
then
  log "File backup succeeded!"
else
  log "File backup failed!"
  exit 1
fi
