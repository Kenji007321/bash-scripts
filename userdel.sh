#!/bin/bash

# Author: Kenji Nakajima
# Last modified: '2024/07/13'
# Description: Simple userdel script. Mainly used for useradd script dry-runs.

for i in "$@"
do
        userdel -r $i
        if [[ $? -eq 0 ]]
        then
        echo "user "$i" deleted"
        fi
done
