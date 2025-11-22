#!/bin/bash

if [ -z "$DEV" ]; then
    echo "set XVM env, export XVM=$HOME/xvm"
    exit 1
fi

FOLDER_APP=""
FOLDER_VERSION=""
DEFAULT_LINK=""
FOLDER_CACHE=""
FOLDER_PROFILE=""
APP_NAME=""

function apply_app_name() {
    FOLDER_APP=$DEV/$APP_NAME
    FOLDER_VERSION=$FOLDER_APP/versions
    DEFAULT_LINK=$FOLDER_APP/default
    FOLDER_CACHE=$FOLDER_APP/cache
    FOLDER_PROFILE=$FOLDER_APP/profile
}
function refresh_path() {
    # echo $DEV
    # cd $DEV
    # ls $DEV
    # $(ls $DEV)
    XVM_PROFILE=$DEV/profile
    # if [ -e $DEV_PROFILE]; then
    # if [ -e "$DEV_PROFILE" ]; then
    #     echo "rmmmm: "$DEV_PROFILE
    #     rm $DEV_PROFILE || true
    # fi

    echo "XVM_PROFILE: "$DEV_PROFILE

    cat >$DEV_PROFILE <<EOF
EOF
    echo "ls: $DEV" $(ls $DEV)

    for i in $(ls $DEV); do
        targetProfile=$DEV/$i/profile
        echo $targetProfile
        # if [ -e "$targetProfile" ] && [ -d "$targetProfile" ]; then
        if [ -e "$targetProfile" ]; then
            echo $targetProfile
            cat >>$DEV_PROFILE <<EOF
source \$DEV/$i/profile
EOF
        fi
    done
}

function util_mkdir_all() {
    # echo "mkdir -p $FOLDER_APP"
    mkdir -p $FOLDER_APP
    mkdir -p $FOLDER_VERSION
    mkdir -p $FOLDER_CACHE
}

function echo_path() {
    echo "FOLDER_APP: "$FOLDER_APP
}

function util_uninstall() {
    # echo "uninstall"
    select_one_ver selectVer $FOLDER_VERSION $@
    rm -rf $FOLDER_VERSION/$selectVer || exit "uninstall fail"
    echo "uninstall $selectVer suc"
}
function util_list() {
    # echo "list"
    vers=$(ls $FOLDER_VERSION)
    for ver in $vers; do
        echo "   " $ver
    done
}
function util_use() {
    # echo "use"
    select_one_ver selectVer $FOLDER_VERSION $@
    targetPath=$FOLDER_VERSION"/"$selectVer"/bin"
    echo "export PATH=$targetPath:\$PATH"
    # eval $(./app.sh use go1.14.6)
}

function util_default_path() {
    vers=$(ls $FOLDER_VERSION)

    if [ -e "$DEFAULT_LINK" ]; then
        targetname=$(readlink $DEFAULT_LINK)
        # $(dirname
        # echo "default: $(basename $targetname)"
    fi

    select_one_ver selectVer $FOLDER_VERSION $@

    if [ -z "$selectVer" ]; then
        echo "your versions is empty"
        exit 1
        return
    fi

    # rm $DEFAULT_LINK 
    # ln -s $FOLDER_VERSION/$selectVer $DEFAULT_LINK
    # echo "set default $selectVer suc"
    # echo "ln -s $FOLDER_VERSION/$selectVer $DEFAULT_LINK"
    # export PATH=$PATH:$DEV/$APP_NAME/default/bin
}

function util_default_go() {
    vers=$(ls $FOLDER_VERSION)

    if [ -e "$DEFAULT_LINK" ]; then
        targetname=$(readlink $DEFAULT_LINK)
        # $(dirname
        # echo "default: $(basename $targetname)"
    fi

    select_one_ver selectVer $FOLDER_VERSION $@

    if [ -z "$selectVer" ]; then
        echo "your versions is empty"
        exit 1
        return
    fi

    # rm $DEFAULT_LINK 
    # ln -s $FOLDER_VERSION/$selectVer $DEFAULT_LINK
    # echo "set default $selectVer suc"
    # echo "ln -s $FOLDER_VERSION/$selectVer $DEFAULT_LINK"

    # targetPath=$FOLDER_VERSION/$selectVer
    # FOLDER_GOPKG=$FOLDER_APP/pkg
    # echo "ln -s $FOLDER_GOPKG $targetPath/gopath/pkg"
    # rm $targetPath/gopath/pkg
    # ln -s $FOLDER_GOPKG $targetPath/gopath/pkg

    # export PATH=$PATH:$DEV/$APP_NAME/default/bin
}
