#!/bin/bash -e
# Usage :
# revit.sh /path/to/file/to/config.rc

FILE="$(realpath "$1")"

REV_FILE="$(realpath --relative-to "$HOME" "${FILE}")"
if [ ! -f "$FILE" ]; then
  echo "$FILE does not exists"
  exit 1
fi
if [ -f "${REV_FILE}" ]; then
  echo "$REV_FILE already exists"
  exit 1
fi

mkdir -p "$(dirname "${REV_FILE}")"
mv "$FILE" "$REV_FILE"
ln -s "$PWD/$REV_FILE" "$FILE"
git add "$REV_FILE"
