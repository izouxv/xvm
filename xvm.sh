#!/bin/bash

PWDX=$(dirname ${BASH_SOURCE[0]})
cd $PWDX

platform=$1

if [ -z "$platform" ]; then
    platform=$(ls -d */ | cut -f1 -d'/')
    echo "platfomr is emtpy, "$platform
else
    shfile="./$platform/app.sh"
    if [ ! -e "$shfile" ]; then
        platform_all=$(ls -d */ | cut -f1 -d'/')
        echo $platform "not support, only support: "$platform_all
        exit 1
    fi
    # ./$platform/app.sh $@
    ./$platform/app.sh ${@:2}
fi

exit 0
