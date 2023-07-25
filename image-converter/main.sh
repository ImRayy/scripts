#!/bin/bash

function main() {
    FUNC=$(gum choose {"1. Convert to WEBP","2. Convert from WEBP"} | cut -d '.' -f 1)

    case "$FUNC" in
    1)
        echo "Lossless not recommended for non PNG files"
        local quality=$(gum choose {0,75,100,lossless})
        for file in $1/*; do
            local filename=$(awk -F '/' '{print $NF}' <<<$file | cut -d '.' -f 1)

            if [[ $quality != "" ]] && [[ $quality != "lossless" ]]; then
                cwebp $file -o $1/"${filename}.webp" -q $quality
                echo "non lossless"
            elif [[ $quality == "lossless" ]]; then
                cwebp $file -o $1/"${filename}.webp" -lossless
            else
                exit
            fi
        done
        ;;
    2)
        for file in $1/*; do
            local filename=$(awk -F '/' '{print $NF}' <<<$file | cut -d '.' -f 1)
            dwebp $file -o $1/"${filename}.png"
        done
        ;;
    *)
        echo "None selected"
        ;;
    esac
}

main $1
