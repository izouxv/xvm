#!/bin/bash

PWDX=$(dirname ${BASH_SOURCE[0]})
source $PWDX/../.util/tools.sh
source $PWDX/../.util/tool_app.sh

APP_NAME="node"

apply_app_name

# # FOLDER_GOPATH=$FOLDER_APP/gopath
# # FOLDER_GOPKGLINK=$FOLDER_GOPATH/pkg/mod
# FOLDER_GOPKG=$FOLDER_APP/pkg

function mkdir_all() {
    util_mkdir_all
    # # mkdir -p $FOLDER_GOPATH
    # mkdir -p $FOLDER_GOPKG
}
# env will set GITHUB_ACCESS_TOKEN

function install() {

    selectVer=$1
    os=$2
    ARCH=$3
    if [ -z "$ARCH" ]; then
        ARCH="x86"
        if [ "$(arch)" = "arm64" ]; then
            ARCH=$(arch)
        fi
    fi
    if [ -z "$os" ]; then
        os=$(platform)
    fi

    if [ -z "$selectVer" ]; then
        if [ ! -z "$GITHUB_ACCESS_TOKEN" ]; then
            # VERS=$(curl --silent -H "Authorization: token $GITHUB_ACCESS_TOKEN" https://api.github.com/repos/golang/go/git/refs/tags | grep -o "go[0-9].[0-9]*[0-9].[0-9]*[0-9]" | uniq)
            # VERS=$(curl --silent -H "Authorization: token $GITHUB_ACCESS_TOKEN" https://api.github.com/repos/golang/go/git/refs/tags | grep -o "go[0-9].[0-9]*[0-9][.0-9]*" | uniq)
            VERS=$(curl --silent -H "Authorization: token $GITHUB_ACCESS_TOKEN" https://api.github.com/repos/nodejs/node/git/refs/tags | grep -o "v[0-9]*[0-9].[0-9]*[0-9][.0-9]*" | uniq)
            echo "select one version"
            select ver in $VERS; do
                echo "You have chosen $ver"
                selectVer=$ver
                break
            done
        fi
    else
        echo $@
    fi

    if [ -z "$selectVer" ]; then
        echo "your must input a verions, eg: v20.6.1"
        exit 1
        return
    fi

    targetPath=$FOLDER_VERSION"/"$selectVer
    if [ -e "$targetPath" ]; then
        echo $selectVer " exist"
        return
    fi

    #get pkg name
    echo "install ver: "$selectVer
    pkgname=""

    # https://nodejs.org/dist/v20.10.0/node-v20.10.0-darwin-x64.tar.gz
    # https://nodejs.org/dist/v20.10.0/node-v20.10.0-darwin-arm64.tar.gz
    # https://nodejs.org/dist/v20.10.0/node-v20.10.0-linux-x64.tar.xz
    # https://nodejs.org/dist/v20.10.0/node-v20.10.0-linux-arm64.tar.xz
    # https://nodejs.org/dist/v20.10.0/node-v20.10.0-win-arm64.zip
    # https://nodejs.org/dist/v20.10.0/node-v20.10.0-win-arm64.zip
    # https://nodejs.org/download/release/v14.21.3/node-v14.21.3-darwin-x64.tar.gz

    baseUrl="https://nodejs.org/dist"
    baseUrl="https://nodejs.org/download/release"

    dirname="node-"$selectVer-$os"-"$ARCH

    echo "dirname: "$dirname
    case "$os" in
    "linux")
        pkgname="node-"$selectVer-$os"-"$ARCH".tar.xz"
        ;;
    "darwin")
        pkgname="node-"$selectVer-$os"-"$ARCH".tar.gz"
        ;;
    "windows")
        pkgname="node-"$selectVer-$os"-"$ARCH".zip"
        ;;
    *)
        echo $"get_all_tags NA: $pf"
        help
        ;;
    esac

    pkg_url="$baseUrl/$selectVer/$pkgname"
    # echo $pkg_url
    # exit 1

    # echo $pkgname
    # echo $selectVer
    # echo $os
    # exit 1

    #if file not exist, download it
    tmpPath=$FOLDER_CACHE"/"$pkgname
    if [ ! -e "$tmpPath" ]; then
        # pkg_url="https://golang.org/dl/$pkgname"
        # pkg_url="https://golang.org/dl/$pkgname"
        # pkg_url="$baseUrl/$pkgname"
        echo "curl -L $pkg_url -o $pkgname.tmp"
        if [ -e "$tmpPath.tmp" ]; then
            rm $tmpPath.tmp
        fi
        curl -L $pkg_url -o $tmpPath.tmp || exit 1
        mv $tmpPath.tmp $tmpPath
    fi

    #extra it to target folder

    tar -zxf $tmpPath -C $FOLDER_CACHE
    echo "mv $FOLDER_CACHE"/$dirname" $targetPath"
    mv $FOLDER_CACHE"/$dirname" $targetPath

    # #link mod
    # mkdir -p $targetPath/gopath/pkg
    # ln -s $FOLDER_GOPKG $targetPath/gopath/pkg/mod
    # mkdir -p $targetPath/gopath/bin
    # echo "ln -s $FOLDER_GOPKG $targetPath/gopath/pkg"
    # rm $targetPath/gopath/pkg
    # ln -s $FOLDER_GOPKG $targetPath/gopath/pkg

    echo "set defaut: "$selectVer
    util_default_path $selectVer

    show_path
    refresh_path

    node -v

    # echo "which go: "$(which go)
}
function show_path() {

    echo $FOLDER_PROFILE
    # rm $FOLDER_PROFILE
    cat >$FOLDER_PROFILE <<EOF
export NODEJS=\$XVM/$APP_NAME/default
export PATH=\$PATH:\$NODEJS/bin 
EOF

}
function search() {
    echo "search"
}

main() {
    mkdir_all

    # show_path
    # refresh_path
    # exit 1

    # echo $FOLDER_PROFILE
    # exit 1

    echo "Total Arguments:" $#
    echo "All Arguments values:" $@
    cd $PWDX
    help() {
        echo "install | uninstall | list | default "
        echo "        use: eval \$(xvm.sh node use v20.6.1)"
        echo "        use: install [v20.6.1])"
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
        util_default_path ${@:2}
        # show_path
        ;;
        # "use")
        #     util_use ${@:2}
        # ;;
    # "search")
    #     search ${@:2}
    #     ;;
    *)
        echo $"NA: $0 $1"
        help
        ;;
    esac
}

main "$@"
