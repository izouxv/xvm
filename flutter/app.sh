#!/bin/bash

PWDX=$(dirname ${BASH_SOURCE[0]})
source $PWDX/../.util/tools.sh
source $PWDX/../.util/tool_app.sh

APP_NAME="flutter"

apply_app_name

# env will set GITHUB_ACCESS_TOKEN

flutter_git="https://github.com/flutter/flutter.git"

function install() {

    selectVer=$1

    if [ -z "$selectVer" ]; then
        if [ ! -z "$GITHUB_ACCESS_TOKEN" ]; then

            # echo $(curl --silent -H "Authorization: token $GITHUB_ACCESS_TOKEN" https://api.github.com/repos/flutter/flutter/git/refs/tags | grep -o "tags/v*[A-Za-z0-9_\-]" | uniq)
            # VERS=$(curl --silent -H "Authorization: token $GITHUB_ACCESS_TOKEN" https://api.github.com/repos/flutter/flutter/git/refs/tags | grep -o "tags/v*[0-9].[0-9]*[0-9].[0-9]*[0-9][^-]" | uniq)
            VERS=$(curl --silent -H "Authorization: token $GITHUB_ACCESS_TOKEN" https://api.github.com/repos/flutter/flutter/git/refs/tags | grep -o "tags/v*[A-Za-z0-9.\-]*" | uniq)

            vers=${VERS//tags\//""}
            # echo "vers: $vers"

            echo "select one version"
            select ver in $vers; do
                echo "You have chosen $ver"
                selectVer=$ver
                break
            done
            # exit 1
        fi
    else
        echo $@
    fi

    if [ -z "$selectVer" ]; then
        echo "your must input a verions, eg: go1.16.4"
        exit 1
        return
    fi

    targetPath=$FOLDER_VERSION"/"$selectVer
    if [ -e "$targetPath" ]; then
        echo $selectVer " exist"
        return
    fi

    # try to extra local pkg
    cahckePkgPath=$FOLDER_CACHE"/"$selectVer".tar.gz"
    if [ -e "$cahckePkgPath" ]; then
        tar -zxf $cahckePkgPath -C $FOLDER_CACHE
        echo "mv $FOLDER_CACHE"/flutter" $targetPath"
        mv $FOLDER_CACHE"/flutter" $targetPath
    else
        # git clone from local git
        git_local_clone $flutter_git $selectVer $FOLDER_CACHE $FOLDER_VERSION
    fi

    # echo "PPP1-" $PATH

    echo "set defaut: "$selectVer
    util_default $selectVer

    # echo "PPP2-" $PATH
    show_path

    #get pkg name
    echo "install ver: "$selectVer

    # echo "PPP3-" $PATH
    echo "eval $(util_use $selectVer)"
    # eval $(util_use $selectVer)
    # echo "which flutter"$(which flutter)
    # echo "PPP4-" $PATH
    flutter doctor
    flutter --version
    flutter doctor --android-licenses

    #extra it to target folder
    # tar -zxf $tmpPath -C $FOLDER_CACHE
    # echo "mv $FOLDER_CACHE"/go" $targetPath"
    # mv $FOLDER_CACHE"/go" $targetPath
}

function git_sync() {
    git_local_sync $FOLDER_CACHE $flutter_git
}

function show_path() {
    echo "export FLUTTER_DIR=$XVM/xvm/flutter/default"
    export FLUTTER_DIR=$XVM/xvm/flutter/default
    echo "export PATH=\$PATH:\$FLUTTER_DIR/bin"
    export PATH=$PATH:$FLUTTER_DIR/bin
    echo "export PATH=\$PATH:\$FLUTTER_DIR/bin/cache/dart-sdk/bin"
    export PATH=$PATH:$FLUTTER_DIR/bin/cache/dart-sdk/bin
}

function search() {
    echo "search"
}

main() {
    util_mkdir_all

    # echo "Total Arguments:" $#
    # echo "All Arguments values:" $@
    cd $PWDX
    help() {
        echo "install | uninstall | use | list | default | sync"
        echo "        use: eval \$(xvm.sh flutter use 2.2.3)"
        echo "        use: install ["", 2.2.3])"
        echo "        use: install 1.17.1_boost util cache 1.17.1_boost.tar.gz"
    }
    if (($# < 1)); then
        help
        exit 1
    fi

    case "$1" in
    "test")
        test
        ;;
    "install")
        install ${@:2}
        ;;
    "uninstall")
        util_uninstall ${@:2}
        ;;
    "list")
        util_list ${@:2}
        ;;
    "default")
        util_default ${@:2}
        show_path
        ;;
    "use")
        util_use ${@:2}
        ;;
        # "search")
        #     search ${@:2}
        #     ;;
    "sync")
        git_sync ${@:2}
        ;;
    *)
        echo $"NA: $0 $1"
        help
        ;;
    esac
}

main "$@"
