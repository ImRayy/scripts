#!/usr/bin/env bash
set -e

selected_files=$(find "${1:-.}"/* -maxdepth 1 -type f | gum choose --no-limit)
file_list=()

while IFS= read -r f; do
    # Strip the leading './' from file names if present
    file_name="${f#./}"
    file_list+=("$file_name")
done <<<"$selected_files"
selected_files_len=${#file_list[@]}

function remove_previous_file_if_exists() {
    if [[ -f "$1" ]]; then
        rm "$1"
    fi
}

function kdeconnect-send() {
    device_id=$(kdeconnect-cli -a --id-only)
    kdeconnect-cli -d "$device_id" --share="$1"
}

function check() {
    if command -v "$1" &>/dev/null; then echo 'yes'; else echo 'no'; fi
}

if [[ $selected_files_len -gt 1 ]]; then

    file_option=$(
        gum choose "1. zip + enctypted" \
            "2. zip + unencrypted" \
            "3. gzip" \
            "4. do not archive" | cut -d '.' -f 2
    )

    # Removes leading space, ex " zip + encrypted" > "zip + encrypted"
    file_option=${file_option# *}

    if [[ "$file_option" != "do not archive" ]]; then
        archive_name=$(gum input --value="archive" \
            --placeholder "Give archive a name: ")
    fi

    case "$file_option" in
    "zip + enctypted")
        file="/tmp/$archive_name.zip"
        remove_previous_file_if_exists "$file"
        zip -r --encrypt "$file" "${file_list[@]}"
        kdeconnect-send "$file"
        ;;
    "zip + unencrypted")
        file="/tmp/$archive_name.zip"
        remove_previous_file_if_exists "$file"
        zip "$file" "${file_list[@]}"
        kdeconnect-send "$file"
        ;;
    "gzip")
        file="/tmp/$archive_name.tar.gz"
        remove_previous_file_if_exists "$file"
        tar czf "$file" "${file_list[@]}"
        kdeconnect-send "$file"
        ;;
    "do not archive")
        for file in "${file_list[@]}"; do
            kdeconnect-send "$file"
        done
        ;;
    *)
        echo "No options selected, exiting..."
        ;;
    esac

else
    kdeconnect-send "${file_list[0]}"
fi
