# LINDS-Puppet
This is all my puppet declarations for certain services across a couple of VM's


**Modules**
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
├── puppetlabs-stdlib (v8.2.0)  invalid
├── saz-timezone (v6.1.0)
├── thias-sysctl (v1.0.7)
└── treydock-yum_cron (v6.2.0)
```

**Puppet.conf of puppet master server**
```
[main]
dns_alt_names = puppet,puppet.linds.com.au
# This file can be used to override the default puppet settings.
# See the following links for more details on what settings are available:
# - https://puppet.com/docs/puppet/latest/config_important_settings.html
# - https://puppet.com/docs/puppet/latest/config_about_settings.html
# - https://puppet.com/docs/puppet/latest/config_file_main.html
# - https://puppet.com/docs/puppet/latest/configuration.html
[server]
vardir = /opt/puppetlabs/server/data/puppetserver
logdir = /var/log/puppetlabs/puppetserver
rundir = /var/run/puppetlabs/puppetserver
pidfile = /var/run/puppetlabs/puppetserver/puppetserver.pid
codedir = /etc/puppetlabs/code
autosign = true
```

**Commands for Client**
```
# rpm -Uvh https://yum.puppet.com/puppet-release-el-8.noarch.rpm
# dnf install puppet-agent
# puppet config set server puppet.linds.com.au
```

**Password files**

Passwords are done by external lookups on a yaml file. This allows flexibility to store more config without showing the password.

/etc/puppetlabs/code/environments/production/data/password.yml

```
---
smb_password: "xxxx"
smb_username: "xxxx"
web_username: "xxxx"
web_password: "xxxxx"
```