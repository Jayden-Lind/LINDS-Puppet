# LINDS-Puppet
This is all my puppet declarations for certain services across a couple of VM's


## Modules
```
├── accounts (???)
├── puppet-autofs (v6.0.0)
├── puppet-chrony (v2.4.0)
├── puppet-epel (v4.1.0)
├── puppet-logrotate (v5.0.0)
├── puppet-selinux (v3.4.0)
├── puppetlabs-concat (v6.4.0)
├── puppetlabs-inifile (v5.3.0)
├── puppetlabs-motd (v6.2.0)
├── puppetlabs-ntp (v9.0.1)
├── puppetlabs-stdlib (v8.2.0)
├── puppetlabs-vcsrepo (v5.2.0)
├── saz-timezone (v6.1.0)
├── thias-sysctl (v1.0.7)
└── treydock-yum_cron (v6.2.0)
```

## Commands for Client

### RHEL/CentOS 8

```
$ rpm -Uvh https://yum.puppet.com/puppet-release-el-8.noarch.rpm
$ dnf install puppet-agent
```

### RHEL/CentOS 9

```
$ rpm -Uvh https://yum.puppet.com/puppet-release-el-9.noarch.rpm
$ dnf install puppet-agent
```

## Password lookups

Passwords are done by external lookups on a yaml file. This file is encrypted with git-crypt.

`/etc/puppetlabs/code/environments/production/data/password.yml`

```
---
smb_password: "xxxx"
smb_username: "xxxx"
web_username: "xxxx"
web_password: "xxxxx"
```