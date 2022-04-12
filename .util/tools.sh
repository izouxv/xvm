#!/bin/bash

function git_local_sync() {

    CACHE_GIT=$1
    originGitResp=$2
    originBareName=$(basename $originGitResp)

    # CACHE_GIT=$HOME/DEV/cache_git
    cd $CACHE_GIT

    if [ -e $originBareName ]; then
        cd $originBareName
        echo "pwd: $(pwd)"
        echo "git fetch --all --tags --prune"
        git fetch --all
    else
        # echo "git clone"
        echo "git clone --mirror $originGitResp"
        git clone --mirror $originGitResp
    fi
}

function git_local_clone() {

    originGitResp=$1
    TAG=$2
    CACHE_GIT=$3
    TARGET_FOLDER=$4

    # originGitResp=ssh://git@git.oauth.red/base/libGo.git
    originBareName=$(basename $originGitResp)
    originName=$(basename -s .git $originGitResp)
    originName=$TARGET_FOLDER
    # pwd=$(PWD)

    # CACHE_GIT=$HOME/DEV/cache_git
    cd $CACHE_GIT

    if [ -e $originBareName ]; then
        cd $originBareName
        echo "pwd: $(pwd)"
        # echo "git fetch --all --tags --prune"
        # git fetch --all
    else
        # echo "git clone"
        echo "git clone --mirror $originGitResp"
        git clone --mirror $originGitResp
    fi

    cd $TARGET_FOLDER

    if [ -e $$originName ]; then
        cd $$originName
        # echo $$originName
        # echo "git fetch local"
        echo "git fetch -l $CACHE_GIT/$originBareName"
        git fetch -l $CACHE_GIT/$originBareName
        git pull
    else
        echo "git clone -b master -l $CACHE_GIT/$originBareName $TARGET_FOLDER/$TAG"
        # mkdir $pwd/$originName
        git clone -b master -l $CACHE_GIT/$originBareName $TARGET_FOLDER/$TAG
        cd $TARGET_FOLDER/$TAG
        git checkout -b testing tags/$TAG #check with tag
        # git clone -b $TAG -l $CACHE_GIT/$originBareName $TARGET_FOLDER/$TAG
    fi

}

function platform() {
    unameOut="$(uname -s)"
    case "${unameOut}" in
    Linux*) machine=linux ;;
    Darwin*) machine=darwin ;;
    CYGWIN*) machine=windows ;;
    MINGW*) machine=windows ;;
    *) machine="UNKNOWN:${unameOut}" ;;
    esac
    echo ${machine}
}

function test() {
    echo "util test active"
}

function select_one_ver() {
    #1: back, 2: FOLDER_VERSION, 3: selectVer
    # echo $@
    #1 is back
    versionFoler=$2
    selectVer=$3

    if [ -z "$selectVer" ]; then
        select ver in $(ls $FOLDER_VERSION); do
            selectVer=$ver
            if [ -z "$selectVer" ]; then
                echo "error chose nothing"
                exit 1
                return
            fi
            echo "You have chosen $ver"
            break
        done
    fi

    ver=$selectVer
    eval "$1=\$ver"
}
