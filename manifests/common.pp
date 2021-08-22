class common {
  $public_key = lookup('ssh_public_key')

  class { 'selinux':
    mode => 'permissive',
    type => 'targeted',
  }

  class { 'timezone':
    timezone => 'Australia/Melbourne',
  }

  class { 'yum_cron':
    apply_updates => true,
  }

  class { 'logrotate' :
    ensure => 'latest',
    config => {
      compress     => true,
      rotate_every => 'week',
    },
  }

  package { 'cifs-utils' :
    ensure     => installed,
  }

  include epel

  include message_of_day

  include ntp

  ssh_authorized_key { 'root@jd-dev-01':
    ensure => present,
    user   => 'root',
    type   => 'ssh-rsa',
    key    => $public_key,
  }
  service { 'puppet':
    ensure => 'running',
    enable => 'true',
  }
  service { 'postfix':
    ensure => 'stopped',
    enable => 'false',
  }

  service { 'firewalld':
    ensure => 'stopped',
    enable => 'false',
  }
  service { 'rsyslog':
    ensure => 'running',
    enable => 'true',
  }
  ini_setting { 'agent_runinterval':
    ensure  => present,
    path    => '/etc/puppetlabs/puppet/puppet.conf',
    section => 'main',
    setting => 'runinterval',
    value   => '21600',
  }
}
