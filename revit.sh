#!/bin/bash

FILE=$1
PREFIX=$2

REV_FILE="${PREFIX}`basename $FILE`"
if [ ! -f $FILE ]; then
  echo $FILE does not exists
  exit 1
fi
if [ -f $REV_FILE ]; then
  echo $REV_FILE already exists
  exit 1
fi

mv $FILE $REV_FILE
ln -s $PWD/$REV_FILE $FILE
git add $REV_FILE
