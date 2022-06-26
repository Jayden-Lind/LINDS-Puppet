class docker {
  yumrepo { 'docker':
    enabled  => 1,
    descr    => 'Docker Repo',
    baseurl  => 'https://download.docker.com/linux/centos/$releasever/$basearch/stable',
    gpgcheck => 1,
    gpgkey   => 'https://download.docker.com/linux/centos/gpg',
  }
  package { 'podman' :
    ensure     => purged,
  }

  if $facts['os']['distro']['release']['full'] == '8' {
    package { 'runc' :
      ensure     => purged,
    }
  }

  if $facts['os']['distro']['release']['full'] == '9' {
    package { 'runc' :
      ensure     => purged,
    }
  }

  package { 'docker-ce' :
    ensure     => installed,
  }
  package { 'docker-ce-cli' :
    ensure     => installed,
  }
  package { 'docker-compose-plugin' :
    ensure     => installed,
  }
  service { 'docker' :
    ensure     => running,
  }
  exec { 'docker-compose' :
    path    => ['/usr/bin', '/usr/sbin', '/bin'],
    command => 'curl -L --fail https://raw.githubusercontent.com/linuxserver/docker-docker-compose/v2/run.sh -o /usr/local/bin/docker-compose && sudo chmod +x /usr/local/bin/docker-compose',
    onlyif  => 'test ! -f /usr/local/bin/docker-compose',
  }
}
