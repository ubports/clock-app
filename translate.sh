#!/bin/bash

if [ -z $1 ]; then
    echo "Please provide the manifest package name";
    exit -1;
fi

cd po

pot_file=$1".pot"

if [ ! -f "$pot_file" ]; then
    echo "Cloudn't find pot file : $pot_file";
    exit -2;
fi

find -name "*.po" -exec msgmerge -U {} $pot_file \;
