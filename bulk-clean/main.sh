#!/bin/bash

folder=${1}
files=$(find $folder -maxdepth 1 -type f | awk -F '.' '{print $NF}' | sort -u)
extension=($(gum choose --no-limit $files))

if [[ -z "$1" ]]; then
    echo -e "> bash main.sh $(gum style --foreground 212 "_files_path_")"
else
    if [[ $files != "" ]]; then
        if [[ ${#extension[@]} -ne 0 ]]; then
            action=$(gum choose {Trash,Delete})
            for i in ${extension[@]}; do
                if [[ $action == "Trash" ]]; then
                    trash $folder/*.$i
                elif [[ $action == "Delete" ]]; then
                    rm $folder/*.$i
                else
                    echo "No action selected"
                fi
            done
        else
            echo "No file type selected"
        fi
    else
        echo "No files found in given directory"
    fi
fi
