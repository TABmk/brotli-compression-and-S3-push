#!/bin/bash

SOURCE_FOLDER="build"
RESULT_FOLDER="result"

mkdir -p $RESULT_FOLDER

get_file_size() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        stat -f%z "$1"
    else
        stat -c%s "$1"
    fi
}

human_readable() {
    local bytes=$1
    if [[ $bytes -lt 1024 ]]; then
        echo "${bytes}B"
    elif [[ $bytes -lt 1048576 ]]; then
        echo "$(( (bytes + 512) / 1024 ))KB"
    else
        echo "$(( (bytes + 524288) / 1048576 ))MB"
    fi
}

show_progress() {
    local width=50
    local percentage=$1
    local completed=$(( (width * percentage) / 100 ))
    local remaining=$((width - completed))
    
    printf "\rProgress: ["
    printf "%${completed}s" | tr ' ' '#'
    printf "%${remaining}s" | tr ' ' '-'
    printf "] %d%%" $percentage
}

files=($(find $SOURCE_FOLDER -type f))
total_files=${#files[@]}

current_file=0
total_original_size=0
total_compressed_size=0

for file in "${files[@]}"; do
    ((current_file++))
    
    percentage=$((current_file * 100 / total_files))
    
    result_dir="$RESULT_FOLDER/$(dirname "${file#$SOURCE_FOLDER/}")"
    mkdir -p "$result_dir"
    
    dest_file="$RESULT_FOLDER/${file#$SOURCE_FOLDER/}"
    
    original_size=$(get_file_size "$file")
    total_original_size=$((total_original_size + original_size))
    
    cat "$file" | brotli --best > "$dest_file"
    
    compressed_size=$(get_file_size "$dest_file")
    total_compressed_size=$((total_compressed_size + compressed_size))
    
    show_progress $percentage
    
    printf "\n%s: %s → %s\n" \
        "$(basename "$file")" \
        "$(human_readable $original_size)" \
        "$(human_readable $compressed_size)"
done

printf "\n\n"

echo "Compression completed!"
echo "Total original size: $(human_readable $total_original_size)"
echo "Total compressed size: $(human_readable $total_compressed_size)"
echo "Space saved: $(human_readable $((total_original_size - total_compressed_size)))"
