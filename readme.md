

version manger, so easy, ^_^
###

run, input you working folder and GITHUB_ACCESS_TOKEN
```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/izouxv/xvm/master/xvm_install.sh)"
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

install with select, (with GITHUB_ACCESS_TOKEN)
```
xvm.sh flutter install 
xvm.sh golang install 
xvm.sh node install 


eg: xvm.sh node install
Total Arguments: 1
All Arguments values: install select one version
1) v0.5.6       157) v0.8.25        313) V4.3.1       469) V9.7.1       625) V14.15.4
2) v0.0.1       158) v0.8.26        314) v4.3.2       470) v9.8.0       626) v14.15.5
...             ...                 ...               ...               ...
155) v0.8.23    311) v4.2.6         467) V9.6.1       623) v14.15.2     779) v21.3.0
156) v0.8.24    312) v4.3.0         468) v9.7.0       624) v14.15.3     780) v21.4.0
#? 780
``` 
install with version (without GITHUB_ACCESS_TOKEN)
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
