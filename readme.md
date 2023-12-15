

version manger, so easy, ^_^
###

run
```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/izouxv/xvm/master/xvm_install.sh)"
input you working folder and GITHUB_ACCESS_TOKEN
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
xvm.sh node install v14.21.3 darwin x64
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
