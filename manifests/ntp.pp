class ntp {
  if $facts['os']['distro']['release']['full'] == '7' {
    class { 'ntp':
      servers        => ['0.au.pool.ntp.org', '1.au.pool.ntp.org'],
      service_manage => true,
    }
  }

  if $facts['os']['distro']['release']['full'] != '8' {
    class { 'chrony':
      servers        => ['0.au.pool.ntp.org', '1.au.pool.ntp.org'],
      service_manage => true,
    }
  }
}
