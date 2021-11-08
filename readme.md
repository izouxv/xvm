

simple simple simple 
###
set .zshrc / .bashrc
```
export XVM=$HOME

export GO111MODULE=on
export GOPATH=$XVM/xvm/golang/gopath
export GOROOT=$XVM/xvm/golang/default
export PATH=$PATH:$GOPATH/bin:$GOROOT/bin

export FLUTTER_DIR=$XVM/xvm/flutter/default
export PATH=$PATH:$FLUTTER_DIR/bin:$FLUTTER_DIR/bin/cache/dart-sdk/bin
```

#####
 
```
xvm.sh  
platfomr is emtpy, flutter golang 

xvm.sh golang
install | uninstall | use | list | default 

xvm.sh flutter
install | uninstall | use | list | default | sync
```

#####

install select version, you need set GITHUB_ACCESS_TOKEN
```
set GITHUB_ACCESS_TOKEN install will fetch all version from github
export GITHUB_ACCESS_TOKEN="ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxx"
```
```
xvm.sh flutter install 
xvm.sh golang install 
``` 
install with version 
```
xvm.sh flutter install 2.5.3
xvm.sh golang install go1.14.3
```


###
select golang version with bash
```
eval $( xvm.sh golang use go1.14.3 )
go version 
eval $( xvm.sh flutter use 2.5.3 )
flutter --version 
```