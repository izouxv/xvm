#!/bin/bash

if [ -z "$XVM" ]; then
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
    FOLDER_APP=$XVM/$APP_NAME
    FOLDER_VERSION=$FOLDER_APP/versions
    DEFAULT_LINK=$FOLDER_APP/default
    FOLDER_CACHE=$FOLDER_APP/cache
    FOLDER_PROFILE=$FOLDER_APP/profile
}
function refresh_path() {
    # echo $XVM
    # cd $XVM
    # ls $XVM
    # $(ls $XVM)
    XVM_PROFILE=$XVM/profile
    # if [ -e $XVM_PROFILE]; then
    # if [ -e "$XVM_PROFILE" ]; then
    #     echo "rmmmm: "$XVM_PROFILE
    #     rm $XVM_PROFILE || true
    # fi

    echo "XVM_PROFILE: "$XVM_PROFILE

    cat >$XVM_PROFILE <<EOF
EOF
    echo "ls: $XVM" $(ls $XVM)

    for i in $(ls $XVM); do
        targetProfile=$XVM/$i/profile
        echo $targetProfile
        # if [ -e "$targetProfile" ] && [ -d "$targetProfile" ]; then
        if [ -e "$targetProfile" ]; then
            echo $targetProfile
            cat >>$XVM_PROFILE <<EOF
source \$XVM/$i/profile
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

    rm $DEFAULT_LINK
    # echo "ln -s $FOLDER_VERSION/$selectVer $DEFAULT_LINK"
    ln -s $FOLDER_VERSION/$selectVer $DEFAULT_LINK
    echo "set default $selectVer suc"
    echo "ln -s $FOLDER_VERSION/$selectVer $DEFAULT_LINK"

    export PATH=$PATH:$XVM/$APP_NAME/default/bin
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

    rm $DEFAULT_LINK
    # echo "ln -s $FOLDER_VERSION/$selectVer $DEFAULT_LINK"
    ln -s $FOLDER_VERSION/$selectVer $DEFAULT_LINK
    echo "set default $selectVer suc"
    echo "ln -s $FOLDER_VERSION/$selectVer $DEFAULT_LINK"

    targetPath=$FOLDER_VERSION/$selectVer
    FOLDER_GOPKG=$FOLDER_APP/pkg
    echo "ln -s $FOLDER_GOPKG $targetPath/gopath/pkg"
    rm $targetPath/gopath/pkg
    ln -s $FOLDER_GOPKG $targetPath/gopath/pkg

    export PATH=$PATH:$XVM/$APP_NAME/default/bin
}
