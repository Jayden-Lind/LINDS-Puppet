class nfs (
  String $nfs_server,
  String $mount_path,
  String $nfs_extra_path = ''
) {
  mount { $mount_path:
    ensure  => mounted,
    device  => "${nfs_server}:${nfs_extra_path}",
    fstype  => 'nfs4',
    options => 'rw,relatime,vers=4.2,rsize=131072,wsize=131072,namlen=255,soft,proto=tcp,timeo=600,retrans=2,sec=sys',
    pass    => 0,
  }
}
