#!/bin/bash

# Check if the correct number of arguments are provided
if [ $# -ne 2 ]; then
  echo "Usage: $0 <slug> <format>"
  exit 1
fi

slug="$1"
format="$2"

srcPath="src/${slug}.typ"
outputPath="page/${slug}.${format}"

# Determine the format-specific path
if [ "${format,,}" = "html" ]; then
  typst watch "$srcPath" --root . --format html --features html --font-path="./assets/fonts" --input fmt=html "$outputPath"
elif [ "${format,,}" = "pdf" ]; then
  typst watch "$srcPath" --root . --format pdf --features html --font-path="./assets/fonts" --input fmt=pdf "$outputPath"
else
  echo "Unsupported format: $format"
  exit 1
fi