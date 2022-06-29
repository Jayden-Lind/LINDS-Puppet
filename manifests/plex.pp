class plex {
  yumrepo { 'plex':
    enabled  => 1,
    descr    => 'Plex Repository',
    baseurl  => 'https://downloads.plex.tv/repo/rpm/$basearch/',
    gpgcheck => 1,
    gpgkey   => 'https://downloads.plex.tv/plex-keys/PlexSign.key',
  }

  sysctl {
    'fs.inotify.max_user_watches' : value => '262144',
  }

#update-crypto-policies --set DEFAULT:SHA1
#allows the plex repo to work on centos 9

  if $facts['os']['distro']['release']['full'] == '9' {
    exec { 'update-crypto-policies --set DEFAULT:SHA1':
      path=> ['/usr/bin', '/usr/sbin',],
    }
  }
  package { 'plexmediaserver' :
    ensure     => latest,
  }
  service { 'plexmediaserver':
    ensure     => running,
  }
}
