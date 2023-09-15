#!/usr/bin/env bash

SUCCESS="\033[0;32m"
PRIMARY="\033[0;34m"
RESET="\033[0m"
IMAGE_EXTENSIONS=("jpg" "jpeg" "png" "gif")

rename() {
    local prefix=$(gum input --placeholder "Enter prefix, EG: AnimeWallpaper-104.jpg, here 'AnimeWallpaper' is a prefix")
    local total_files=$(find $1/ -maxdepth 1 -type f \( -name "*.png" -o -name "*.jpg" -o -name "*.jpeg" -o -name "*.gif" \) | wc -l)
    local current_file=1

    if [[ -z $prefix ]]; then
        echo "Prefix cannot be empty. Exiting with error code 1"
        exit 1
    fi

    for image in $1/*; do
        local extension="${image##*.}"
        if [[ " ${IMAGE_EXTENSIONS[*]} " == *" $extension "* ]]; then
            local filename=$(awk -F '/' '{print $NF}' <<<$image | cut -d '.' -f 1)
            local rename_format="${prefix}-${current_file}.${extension}"
            echo "$filename" "->" "$rename_format" >>"$1"/rename-history.txt
            mv "$image" "$1/$rename_format"
            ((current_file = current_file + 1))
        fi
        local current_progress=$((($current_file * 100) / $total_files))
        if [[ $current_progress != 101 ]]; then
            echo -ne "${PRIMARY}Progress: $current_progress%\r"
        fi
    done
    echo ""
    echo -e "${SUCCESS}Done :)"
}

rename $1
