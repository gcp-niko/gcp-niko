#!/bin/bash
# Check if a filename is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <filename>"
  exit 1
fi
# Search for strings starting with ${ and ending with }
grep -o '\${[^}]*}' "$1" | sed 's/[${}]//g' | sed 's/$/=/g' | sort | uniq