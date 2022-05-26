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

    selectVer=$1

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
    arch="amd64"
    arch="arm64"
    os=$(platform)
    case "$os" in
    "linux")
        pkgname=$selectVer"."$os"-"$arch".tar.gz"
        ;;
    "darwin")
        pkgname=$selectVer"."$os"-"$arch".tar.gz"
        ;;
    "windows")
        pkgname=$selectVer"."$os"-"$arch".zip"
        ;;
    *)
        echo $"get_all_tags NA: $pf"
        help
        ;;
    esac

    #if file not exist, download it
    tmpPath=$FOLDER_CACHE"/"$pkgname
    if [ ! -e "$tmpPath" ]; then
        # pkg_url="https://golang.org/dl/$pkgname"
        # pkg_url="https://golang.org/dl/$pkgname"
        pkg_url="https://golang.google.cn/dl/$pkgname"
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
    util_default $selectVer
    show_path

    go version

    # echo "which go: "$(which go)
}
function show_path() {
    echo "export GO111MODULE=on"
    export GO111MODULE=on
    echo "export GOROOT=\$XVM/xvm/$APP_NAME/default"
    export GOROOT=$XVM/xvm/$APP_NAME/default
    echo "export GOPATH=\$GOROOT/gopath"
    export export GOPATH=$GOROOT/gopath
    echo "export PATH=\$PATH:\$GOPATH/bin:\$GOROOT/bin"
    export PATH=$PATH:$GOPATH/bin:$GOROOT/bin
}
function search() {
    echo "search"
}

main() {
    mkdir_all

    # echo "Total Arguments:" $#
    # echo "All Arguments values:" $@
    cd $PWDX
    help() {
        echo "install | uninstall | use | list | default "
        echo "        use: eval \$(xvm.sh golang use go1.14.6)"
        echo "        use: install ["", go1.14.6])"
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
        # show_path
        ;;
    "use")
        util_use ${@:2}
        ;;
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
