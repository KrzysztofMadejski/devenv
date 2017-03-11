#!/bin/bash

# top-ing selected processes
top -p $(ps aux | grep datastore | awk '{print $2}' | paste -sd ',')

# checking who is trying to access file

1)
sudo apt-get install inotify-tools
inotifywait -e /path/to will print a line /path/to/ ACCESS file when someone reads file
This interface won't tell you who accessed the file;

2)
sudo apt-get install auditd
auditctl -w /path/to/file
auditctl -@ /path/to/file # unwatch
tail -f /var/log/audit/audit.log

