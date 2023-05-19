#!/bin/sh

FILES="./*"

for f in $FILES
do
  if [ "$f" != "$0" ]; then
    echo "Processing $f file..."
    source "$f"
  fi
done

