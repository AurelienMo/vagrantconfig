# Vagrant configuration

## Stack tech
- PHP 7.2 FPM
- Apache
- Mysql
- NodeJS / NPM
- Make

## Configuration VM
- Into Vagrantfile file:
1. Update all **host** port to avoid conflict with another virtual machine
2. You want more speedup vm ? Juste update `vb.memory` and `vb.cpus` values
3. Update `config.vm.hostname` according your project
- Into bootstrap.sh file:
1. Define database name: define value on line 5 `DBNAME=applicationname`

You can update the files and folder excluded from sync when editing the vm into Vagrantfile on line `10` & `11`
## Root directory

Default root to **/var/www/html/web** (Symfony 3*)
If your entrypoint is locate into **public** folder, just following next step:
- Just replace following line into bootstrap.sh file
```
//Update /var/www/html/web here
sed -i "s#DocumentRoot /var/www/html#DocumentRoot /var/www/html/web#g" /etc/apache2/sites-available/000-default.conf
```

## Mail catcher
A mail catcher is run after build.
- Web interface access on url : `http://localhost:PORT_INTO_VAGRANTFILE`   
- Port SMTP to catch mail: `1025`

## Vagrant command
- Run vagrant: `vagrant up`
- Update provision after update bootstrap.sh: `vagrant reload --provision`
- Stop VM: `vagrant halt`
- Destroy VM: `vagrant destroy` WARNING : All datas on vm are lost.
