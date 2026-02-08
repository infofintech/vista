#!/bin/bash

for file in *.png; do
    # Skip if file doesn't exist (in case no .png files)
    [[ -f "$file" ]] || continue

    # Extract base name (without .png extension)
    base="${file%.png}"
    
    # Check if base contains a dot (i.e., matches pkgname.suffix pattern)
    if [[ "$base" != *.* ]]; then
        # No dot → doesn't match exclusion pattern → process it
        mogrify "$file" -resize 640x640 -quality 100 "$file"
        echo "Processed: $file"
        continue
    fi

    # Split into pkgname and suffix (last part after last dot)
    pkgname="${base%%.*}"  # Everything before last dot
    suffix="${base#*.}"     # Everything after last dot

    # Define excluded suffixes
    excluded_suffixes=(
        "torso"
        "left0" "left90" "left180" "left270"
        "right0" "right90" "right180" "right270"
        "screenshot"
    )

    # Check if suffix is in excluded list
    skip=false
    for excluded in "${excluded_suffixes[@]}"; do
        if [[ "$suffix" == "$excluded" ]]; then
            skip=true
            break
        fi
    done

    if $skip; then
        echo "Skipped (excluded pattern): $file"
    else
        mogrify "$file" -resize 640x640 -quality 100 "$file"
        echo "Processed: $file"
    fi
done