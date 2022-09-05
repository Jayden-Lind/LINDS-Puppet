![image](/img/Puppet_Logo.svg)

# LINDS-Puppet

Uses open source [Puppet](https://puppet.com/try-puppet/open-source-puppet/) to provision servers.

## Hiera

[Hiera](https://puppet.com/docs/puppet/7/hiera.html) is used to allow easy code re use, and site specific data.

### Custom Facts

1. host_code
> Determined by splitting by `-`. Is the first value in the list
2. application
> Determined by application by `-`. Is the second value in the list

eg: **jd-kube-01**

1. `jd` is the host_code
2. `kube` is the application

## Modules
``` bash
[root@JD-Puppet-Master production]$ puppet module list
/etc/puppetlabs/code/environments/production/modules
├── custom (???)
├── puppet-autofs (v7.0.0)
├── puppet-chrony (v2.5.0)
├── puppet-epel (v4.1.0)
├── puppet-logrotate (v6.1.0)
├── puppet-selinux (v3.4.1)
├── puppetlabs-concat (v7.2.0)
├── puppetlabs-inifile (v5.3.0)
├── puppetlabs-motd (v6.2.0)
├── puppetlabs-ntp (v9.2.0)
├── puppetlabs-puppetserver_gem (v1.1.1)
├── puppetlabs-stdlib (v8.4.0)
├── puppetlabs-vcsrepo (v5.2.0)
├── saz-timezone (v6.2.0)
├── thias-sysctl (v1.0.7)
└── treydock-yum_cron (v6.2.0)
[root@JD-Puppet-Master production]$
```

## Install by client

### RHEL/CentOS 8

``` sh
rpm -Uvh https://yum.puppet.com/puppet-release-el-8.noarch.rpm
dnf install puppet-agent
```

### RHEL/CentOS 9

``` sh
rpm -Uvh https://yum.puppet.com/puppet-release-el-9.noarch.rpm
dnf install puppet-agent
```

### Ubuntu

``` sh
wget https://apt.puppet.com/puppet7-release-focal.deb
sudo dpkg -i puppet7-release-focal.deb
```
