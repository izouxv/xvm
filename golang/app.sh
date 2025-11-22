#!/bin/bash

PWDX=$(dirname ${BASH_SOURCE[0]})
source $PWDX/../.util/tools.sh
source $PWDX/../.util/tool_app.sh

APP_NAME="golang"

apply_app_name

# # FOLDER_GOPATH=$FOLDER_APP/gopath
# # FOLDER_GOPKGLINK=$FOLDER_GOPATH/pkg/mod
FOLDER_GOPKG=$FOLDER_APP/pkg

function mkdir_all() {
    util_mkdir_all
    # # mkdir -p $FOLDER_GOPATH
    mkdir -p $FOLDER_GOPKG
}
# env will set GITHUB_ACCESS_TOKEN

function install() {
    # ./xvm.sh golang install go1.22.4 linux arm64

    selectVer=$1
    os=$2
    ARCH=$3
    if [ -z "$ARCH" ]; then
        ARCH="amd64"
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
            VERS=$(curl --silent -H "Authorization: token $GITHUB_ACCESS_TOKEN" https://api.github.com/repos/golang/go/git/refs/tags | grep -o "go[0-9].[0-9]*[0-9][.0-9]*" | uniq)
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
        echo "your must input a verions, eg: go1.16.4"
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

    # ARCH="amd64"
    # if [ "$(arch)" = "arm64" ]; then
    #     ARCH=$(arch)
    # fi

    case "$os" in
    "linux")
        pkgname=$selectVer"."$os"-"$ARCH".tar.gz"
        ;;
    "darwin")
        pkgname=$selectVer"."$os"-"$ARCH".tar.gz"
        ;;
    "windows")
        pkgname=$selectVer"."$os"-"$ARCH".zip"
        ;;
    *)
        echo $"get_all_tags NA: $pf"
        help
        ;;
    esac

    # echo $pkgname
    # echo $selectVer
    # echo $os
    # exit 1

    #if file not exist, download it
    tmpPath=$FOLDER_CACHE"/"$pkgname
    if [ ! -e "$tmpPath" ]; then
        # pkg_url="https://golang.org/dl/$pkgname"
        # pkg_url="https://golang.org/dl/$pkgname"
        # pkg_url="https://golang.google.cn/dl/$pkgname"
        pkg_url="https://go.dev/dl/$pkgname"

        echo "curl -L $pkg_url -o $pkgname.tmp"
        rm $tmpPath.tmp
        curl -L $pkg_url -o $tmpPath.tmp || exit 1
        mv $tmpPath.tmp $tmpPath
    fi

    #extra it to target folder

    tar -zxf $tmpPath -C $FOLDER_CACHE
    echo "mv $FOLDER_CACHE"/go" $targetPath"
    mv $FOLDER_CACHE"/go" $targetPath

    # #link mod
    # mkdir -p $targetPath/gopath/pkg
    # ln -s $FOLDER_GOPKG $targetPath/gopath/pkg/mod
    mkdir -p $targetPath/gopath/bin
    # echo "ln -s $FOLDER_GOPKG $targetPath/gopath/pkg"
    # rm $targetPath/gopath/pkg
    # ln -s $FOLDER_GOPKG $targetPath/gopath/pkg

    echo "set defaut: "$selectVer
    util_default_go $selectVer
    show_path
    refresh_path

    go version

    # echo "which go: "$(which go)
}
function show_path() {

    cat >$FOLDER_PROFILE <<EOF
export GO111MODULE=on
export GOROOT=\$DEV/$APP_NAME/default
export GOPATH=\$GOROOT/gopath
export PATH=\$PATH:\$GOPATH/bin:\$GOROOT/bin
EOF

}
function search() {
    echo "search"
}

main() {
    mkdir_all

    # # refresh_path
    # show_path
    # exit 1

    # echo "Total Arguments:" $#
    # echo "All Arguments values:" $@
    cd $PWDX
    help() {
        echo "install | uninstall | list | default "
        echo "        use: eval \$(xvm.sh golang use go1.14.6)"
        echo "        use: install [go1.14.6, windows])"
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
        util_default_go ${@:2}
        # show_path
        ;;
    # "use")
    #     util_use ${@:2}
    #     ;;
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
