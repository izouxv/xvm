#/bin/bash

read -p "Enter a working folder(abs path, default: \$HOME/DEV): " workingfolder
if [ -z "$workingfolder" ]; then
    workingfolder=$HOME/DEV
fi
if [ -e "$workingfolder" ]; then
    echo "folder: $workingfolder exist, please check, and try again"
    exit 0
fi

read -p "Enter your github access token: " GITHUB_ACCESS_TOKEN
if [ -z "$GITHUB_ACCESS_TOKEN" ]; then
    echo "github access token MUST be setted"
    exit 0
fi

echo "You workingfolder: $workingfolder"
echo "You github access token: $GITHUB_ACCESS_TOKEN"

# ###########################################
# function show_path() {
#     cat >$DEV/xvm/profile <<EOF
# export GITHUB_ACCESS_TOKEN=$GITHUB_ACCESS_TOKEN
# EOF
# }
# function import_path() {
#     outputFile=$@
#     if [ -e "$outputFile" ]; then
#         cat >>$outputFile <<EOF
# export XVM=$workingfolder
# export PATH=\$PATH:\$DEV/xvm
# source \$DEV/profile
# EOF
#     fi
# }

# export XVM=$workingfolder
# PATH=$PATH:$DEV/xvm
# source $DEV/xvm/.util/tool_app.sh
# show_path
# refresh_path

# import_path $HOME/.bashrc
# import_path $HOME/.zshrc

# exit 0

###########################################

function yes_or_no {
    while true; do
        read -p "$*confirm? [y/n]: " yn
        case $yn in
        [Yy]*) return 0 ;;
        [Nn]*)
            echo "Aborted"
            exit 0
            ;;
        esac
    done
}

yes_or_no "$message" #&& do_something

mkdir -p $workingfolder
cd $workingfolder
git clone https://github.com/izouxv/xvm.git

function show_path() {
    cat >$DEV/xvm/profile <<EOF
export GITHUB_ACCESS_TOKEN=$GITHUB_ACCESS_TOKEN
EOF
}

function import_path() {
    outputFile=$@
    if [ -e "$outputFile" ]; then
        cat >>$outputFile <<EOF
export XVM=$workingfolder
export PATH=\$PATH:\$DEV/xvm
source \$DEV/profile
EOF
    fi
}

export XVM=$workingfolder
PATH=$PATH:$DEV/xvm
source $DEV/xvm/.util/tool_app.sh

show_path
refresh_path

import_path $HOME/.bashrc
import_path $HOME/.zshrc

exit 0
