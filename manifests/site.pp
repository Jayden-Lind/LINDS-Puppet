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
    extra_path => '/server/backup',
  }
}

node 'jd-docker-01.linds.com.au', 'jd-dev-01.linds.com.au', 'jd-dev-02.linds.com.au' {
  include common
  include docker
}

node 'linds-docker-01.linds.com.au', 'linds-docker-02.linds.com.au' {
  include common
  include docker
  class { 'nfs':
    nfs_server     => 'linds-truenas-01.linds.com.au',
    nfs_extra_path => '/mnt/ZFS_NAS',
    mount_path     => '/var/lib/docker/volumes/nfs_nas/_data',
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
  class { 'nfs':
    nfs_server     => 'linds-truenas-01.linds.com.au',
    nfs_extra_path => '/mnt/ZFS_NAS',
    mount_path     => '/mnt/nas',
  }
}

node 'jd-torrent-01.linds.com.au' {
  include common
}

node /^.*-kube-\d\d/ {
  include common
  include kubernetes
}
