#!/usr/bin/env bash

DESKTOP_THRESHOLD=1.2

function sort() {
    mkdir $1/{Desktop,Mobile}
    for image in $1/*; do
        if [[ -f $image ]]; then
            image_threshold=$(identify -format "%[fx:w/h]\n" $image)
            if awk -v image_threshold="$image_threshold" -v desktop="$DESKTOP_THRESHOLD"\
                'BEGIN { if ( image_threshold >= desktop ) exit 0; else exit 1 }'; then
                mv $image $1/Desktop
            else
                mv $image $1/Mobile
            fi

        fi
    done
}

sort $1
