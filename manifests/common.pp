class common {
  $public_key = lookup('ssh_public_key')

  package { 'cifs-utils' :
    ensure     => latest,
  }

  package { 'nfs-utils' :
    ensure     => latest,
  }

  package { 'python3' :
    ensure => latest,
  }

  include message_of_day

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
    value   => '6h',
  }
}
