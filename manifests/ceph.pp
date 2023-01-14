class ceph_linds (
  $client = false,
  $server = false,
) {
  $admin_key = "AQBP1rJjO3fkNBAA06VFJ2YtX78eVb/5/wXEkg=="
  $fsid = "a072c93b-6d4f-4235-8fc5-0787a8c80b05"
  $mon_key = "AQBK1rJjmSFLDBAAl3K6oW8Vtwr3S4itPbroMw=="
  $bootstrap_osd_key = "AQBU1rJjmzAMNRAAzFJPsYqJ9I+JTAKSRQmP2Q=="
  $mgr_key = "AQCLmbZjwPB/ORAA9hKtixCjg3FRtYf7q4kIxg=="
  $mds_key = "AQC/yrhjPqIyBRAAV/Sm7M69AMNe/48KsiZDtg=="

  class { 'ceph::repo':
    stream      => true,
    enable_sig  => true,
    enable_epel => false,
    release     => 'quincy',
  }
  class { 'ceph':
    fsid                      => $fsid,
    #mon_host                  => '10.0.53.5',
    mon_host                  => $facts['networking']['ip'],
    # create initial mon host first to get them to join the cluster then add the rest of the mon hosts
    authentication_type       => 'cephx',
    osd_pool_default_size     => '2',
    osd_pool_default_min_size => '2',
  }

  if $server == true {
    ceph::mon { $facts['networking']['hostname'].downcase():
      public_addr         => $facts['networking']['ip'],
      authentication_type => 'cephx',
      key                 => $mon_key,
    }
    ceph::mgr { $facts['networking']['hostname'].downcase():
      key        => $mgr_key,
      inject_key => true,
    }
    ceph::fs { 'linds':
      metadata_pool => 'cephfs_pool',
      data_pool     => 'cephfs_pool',
    }
    Ceph::Key {
      inject         => true,
      inject_as_id   => 'mon.',
      inject_keyring => "/var/lib/ceph/mon/ceph-${facts['networking']['hostname'].downcase()}/keyring",
    }
    ceph::key { 'client.admin':
      secret  => $admin_key,
      cap_mon => 'allow *',
      cap_osd => 'allow *',
      cap_mds => 'allow *',
      cap_mgr => 'allow *',
    }
    ceph::key { 'client.bootstrap-osd':
      secret       => $bootstrap_osd_key,
      cap_mon      => 'allow profile bootstrap-osd',
      keyring_path => '/var/lib/ceph/bootstrap-osd/ceph.keyring',
      user         => 'ceph',
      group        => 'ceph',
    }
    ceph::key { "mds.${facts['networking']['hostname']}":
      secret       => $mds_key,
      cap_osd      => 'allow rwx',
      cap_mds      => 'allow',
      cap_mon      => 'allow profile mds',
      keyring_path => "/var/lib/ceph/mds/ceph-${facts['networking']['hostname']}/keyring",
      user         => 'ceph',
      group        => 'ceph',
    }
    ceph::osd { '/dev/sdb':
      store_type => 'bluestore',
      fsid       => $fsid,
    }
    ceph::pool { 'cephfs_pool':
      ensure => present,
      size   => 2,
      tag    => 'cephfs',
    }
    class { 'ceph::mds':
      keyring => "/var/lib/ceph/mds/ceph-${facts['networking']['hostname']}/keyring",
    }
  }
  if $client == true {
    file { '/root/admin.key':
      owner   => 'root',
      group   => 'root',
      content => $admin_key,
    }
    file { '/mnt/test':
      ensure => directory,
    }
    mount { 'Ceph Cluster':
      ensure  => 'mounted',
      name    => '/mnt/test',
      fstype  => 'ceph',
      device  => ':/',
      options => "name=admin,secret=${admin_key}",
    }
  }
}
