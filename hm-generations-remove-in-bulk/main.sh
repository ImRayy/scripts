#!/usr/bin/env bash

generations=$(home-manager generations | awk '{print $5}')
first_gen_id=`echo $generations | awk '{print $NF}'`
last_gen_id=`echo $generations | awk '{print $1}'`
total_generations=$(($last_gen_id - $first_gen_id))

echo "Total ${total_generations} generations found, ${first_gen_id}-${last_gen_id}"

generations_to_keep=`gum input --placeholder "How many recent generations to keep?"`
generations_to_remove=`echo "$generations" | tail -n +"$((generations_to_keep + 1))"`

gum spin --spinner="dot" --title="Cleaning up generation..." -- home-manager remove-generations $generations_to_remove

echo "Success!"
