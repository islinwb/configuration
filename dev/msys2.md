### for IDE
```
C:\msys64\msys2_shell.cmd -defterm -here -no-start -ucrt64
```



```bash
mkpasswd -l -c > /etc/passwd
mkgroup -l -c > /etc/group
```

```
# Begin /etc/nsswitch.conf
passwd: files
group: files
db_enum: cache builtin
db_home: cygwin desc
db_shell: cygwin desc
db_gecos: cygwin desc
# End /etc/nsswitch.conf
```