#!/bin/bash

function welcome_msg() {
    gum style --margin "1 0" --padding "1 2" --border double --border-foreground 212 "$(gum style --foreground 212 'Image Converter')"
}

function convert() {
    FUNC=$(gum choose {"1. Convert to WEBP","2. Convert from WEBP"} | cut -d '.' -f 1)

    case "$FUNC" in
    1)
        echo "Lossless not recommended for non PNG files"
        local quality=$(gum choose {0,75,100,lossless})
        function hello() {
            tree /home/$USER/
        }

        local total_files=$(find $1/ -type f | wc -l)
        local current_file=1
        for file in $1/*; do

            local filename=$(awk -F '/' '{print $NF}' <<<$file | cut -d '.' -f 1)
            echo "$(tput cuu1 & tput el & gum style --foreground 212 ${current_file}) of $(gum style --foreground 212 ${total_files})"

            if [[ $quality != "" ]] && [[ $quality != "lossless" ]]; then
                gum spin --spinner dot --title "Converting..." -- \
                    cwebp $file -o $1/"${filename}.webp" -q $quality
            elif [[ $quality == "lossless" ]]; then
                gum spin --spinner dot --title "Converting..." -- \
                    cwebp $file -o $1/${filename}.webp -lossless
            else
                exit
            fi
            ((current_file = current_file + 1))
        done
        echo ""
        gum style --foreground 40 "Successful!"
        echo ""
        ;;
    2)
        for file in $1/*; do
            local filename=$(awk -F '/' '{print $NF}' <<<$file | cut -d '.' -f 1)
            gum spin --spinner dot --title "Converting..." -- \
                dwebp $file -o $1/"${filename}.png"
        done
        ;;
    *)
        echo "None selected"
        ;;
    esac
}

function main() {
    if [[ -z "$1" ]]; then
        echo -e "> bash main.sh $(gum style --foreground 212 "_files_path_")"
    else
        welcome_msg
        convert $1
    fi
}

main $1
