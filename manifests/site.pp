node default {
  include common
}

node 'jd-backup-01.linds.com.au' {
  include common
  include backup
  class { 'auto_fs_nas':
    nas_server => 'jd-dc-01',
    mount_path => '/mnt/',
    mount_dir  => 'nas',
    extra_path => '/server/backup/wordpress',
  }
}

node 'jd-docker-01.linds.com.au', 'jd-dev-01.linds.com.au', 'jd-dev-02.linds.com.au' {
  include common
  include docker
}

node 'linds-docker-01.linds.com.au', 'linds-docker-02.linds.com.au' {
  include common
  include docker
  class { 'auto_fs_nas':
    nas_server => 'linds-dc',
    mount_path => '/var/lib/docker/volumes/nfs_nas/',
    mount_dir  => '_data',
  }
}

node 'jd-plex-01.linds.com.au' {
  include common
  include plex
  class { 'auto_fs_nas':
    nas_server => 'jd-dc-01',
    mount_path => '/mnt/',
    mount_dir  => 'nas',
  }
}

node 'linds-plex-01.linds.com.au' {
  include common
  include plex
  class { 'auto_fs_nas':
    nas_server => 'linds-dc',
    mount_path => '/mnt/',
    mount_dir  => 'nas',
  }
}

node 'jd-torrent-01.linds.com.au' {
  include common
}

node 'jd-kube-01.linds.com.au', 'jd-kube-02.linds.com.au', 'jd-kube-03.linds.com.au' {
  include common
  include kubernetes
}
