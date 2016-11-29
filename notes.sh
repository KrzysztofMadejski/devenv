#!/bin/bash

# top-ing selected processes
top -p $(ps aux | grep datastore | awk '{print $2}' | paste -sd ',')
