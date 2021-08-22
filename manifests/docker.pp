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

  package { 'docker-ce':
    ensure     => installed,
  }
  package { 'docker-ce-cli':
    ensure     => installed,
  }
  package { 'docker-compose-plugin':
    ensure     => installed,
  }
  service { 'docker':
    ensure     => running,
  }
}
