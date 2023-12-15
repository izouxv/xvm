

version manger, so easy, ^_^
###
```
clone https://github.com/izouxv/xvm.git
```
set .zshrc / .bashrc
```

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/izouxv/xvm/master/xvm_install.sh)"


PATH=$PATH:[your xvm project path]
export XVM=$[XVM folder, eg: $HOME/XVM]
source $XVM/profile
#set GITHUB_ACCESS_TOKEN install will fetch all version from github
export GITHUB_ACCESS_TOKEN="ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxx"

```

#####
 
```
xvm.sh  
platfomr is emtpy, flutter golang 

xvm.sh golang
install | uninstall | list | default 

xvm.sh node
install | uninstall | list | default 

xvm.sh flutter
install | uninstall | use | list | default | sync
```

#####

install select version, you need set GITHUB_ACCESS_TOKEN
```
set GITHUB_ACCESS_TOKEN install will fetch all version from github
export GITHUB_ACCESS_TOKEN="ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxx"
```
install 
```
xvm.sh flutter install 
xvm.sh golang install 
xvm.sh node install 
``` 
install with version 
```
xvm.sh flutter install 2.5.3
xvm.sh golang install go1.14.3
xvm.sh node install v21.4.0
```
switch version 
```
xvm.sh flutter default 2.5.3   //switch to flutter 2.5.3
xvm.sh golang default go1.14.3 //switch to golang 1.14.3
xvm.sh golang default go1.21.1 //switch to golang 1.21.1
xvm.sh node default v21.4.0    //switch to node v21.4.0
```


<!-- ###
select golang version with bash
```
eval $( xvm.sh golang use go1.14.3 )
go version 
eval $( xvm.sh flutter use 2.5.3 )
flutter --version 
``` -->
