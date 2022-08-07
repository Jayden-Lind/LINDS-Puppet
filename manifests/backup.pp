class backup {
  $username = lookup('web_username')
  cron { 'scp':
    command => "/usr/bin/scp -i ~/.ssh/id_rsa_backup ${username}@10.0.60.2:/home/${username}/backup/* /mnt/nas/wordpress",
    user    => 'root',
    minute  => 0,
    hour    => 4,
    weekday => 1,
  }

  package { 'git' :
    ensure => latest,
  }

  $opnsense_repo_path = '/root/OPNSense-backup/'

  vcsrepo { $opnsense_repo_path:
    ensure   => present,
    provider => git,
    source   => 'https://github.com/Jayden-Lind/OPNSense-Backup.git',
  }

  $hpe_repo_path = '/root/HPE-switch-backup'

  vcsrepo { $hpe_repo_path:
    ensure   => present,
    provider => git,
    source   => 'https://github.com/Jayden-Lind/HPE-OfficeConnect-Backup.git',
  }

  $linds_opnsense = '192.168.6.1'
  $jd_opnsense = '10.0.50.1'

  $jd_opnsense_api_key = lookup('jd_opnsense_api_key')
  $jd_opnsense_api_secret = lookup('jd_opnsense_api_secret')
  cron { 'scp_opnsense_jd':
    command => "cd ${$opnsense_repo_path} && python3 backup.py ${jd_opnsense} ${$jd_opnsense_api_key} ${$jd_opnsense_api_secret}",
    user    => 'root',
    minute  => '0',
    hour    => '1',
    weekday => '1',
  }

  $linds_opnsense_api_key = lookup('linds_opnsense_api_key')
  $linds_opnsense_api_secret = lookup('linds_opnsense_api_secret')
  cron { 'scp_opnsense_linds':
    command => "cd ${$opnsense_repo_path} && python3 backup.py ${linds_opnsense} ${$linds_opnsense_api_key} ${$linds_opnsense_api_secret}",
    user    => 'root',
    minute  => '0',
    hour    => '1',
    weekday => '1',
  }

  cron { 'scp_to_nas':
    command => "/bin/bash -c 'cp ${$opnsense_repo_path} 1* /mnt/nas'",
    user    => 'root',
    minute  => '0',
    hour    => '2',
    weekday => '1',
  }

  $switch_hostname = '10.0.0.2'
  $switch_username = lookup('switch_username')
  $switch_password = lookup('switch_password')
  cron { 'scp_switch_linds':
    command => "cd ${$hpe_repo_path} && python3 backup.py ${switch_hostname} ${switch_username} ${switch_password}",
    user    => 'root',
    minute  => '0',
    hour    => '1',
    weekday => '1',
  }

  cron { 'scp_to_nas_hpe':
    command => "/bin/bash -c 'cp ${$hpe_repo_path} 1* /mnt/nas'",
    user    => 'root',
    minute  => '0',
    hour    => '2',
    weekday => '1',
  }
}
