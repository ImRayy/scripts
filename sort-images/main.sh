#!/usr/bin/env bash

DESKTOP_THRESHOLD=1.2
BLUE="\033[0;34m"
CYAN="\033[0;36m"
YELLOW="\033[1;33m"
GREEN="\033[0;32m" 
NC="\033[0m"

function progress_bar() {
    percentage=$1
    if [[ $percentage -ge 0 && $percentage -lt 10 ]]; then  
        echo -ne "[                      ] 0%\r"
    elif [[ $percentage -ge 10 && $percentage -lt 20 ]]; then
        echo -ne "[${YELLOW}====                       ${NC}] 20%\r"
    elif [[ $percentage -ge 20 && $percentage -lt 40 ]]; then
        echo -ne "[${YELLOW}=======                   ${NC}] 40%\r"
    elif [[ $percentage -ge 40 && $percentage -lt 60 ]]; then
        echo -ne "[${BLUE}==============            ${NC}] 60%\r"
    elif [[ $percentage -ge 60 && $percentage -lt 80 ]]; then
        echo -ne "[${CYAN}=======================   ${NC}] 80%\r"
    elif [[ $percentage -ge 80 && $percentage -le 100 ]]; then
        echo -ne "[${GREEN}==========================${NC}] 100%\r"
    fi
}

function sort() {
    total_files=$(find $1 -maxdepth 1 -type f | wc -l)
    current_file=0
    mkdir $1/{Desktop,Mobile}
    for image in $1/*; do
        if [[ -f $image ]]; then
            image_threshold=$(identify -format "%[fx:w/h]\n" "$image")
            if awk -v image_threshold="$image_threshold" -v desktop="$DESKTOP_THRESHOLD" \
                'BEGIN { if ( image_threshold >= desktop ) exit 0; else exit 1 }'; then
                mv "$image" $1/Desktop
            else
                mv "$image" $1/Mobile
            fi
            ((current_file = current_file + 1))
        fi
        current_progress=$(( ($current_file * 100 ) / $total_files ))
        progress_bar $current_progress
    done
    echo -ne '\n'
    echo -e "${GREEN}Success!"
}

sort $1
