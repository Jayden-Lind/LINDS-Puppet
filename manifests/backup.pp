class backup {
  $username = lookup('web_username')
  cron { 'scp':
    command => "/usr/bin/scp -i ~/.ssh/id_rsa_backup ${username}@10.0.60.2:/home/${username}/backup/* /mnt/nas/",
    user    => 'root',
    minute  => 0,
    hour    => 4,
    weekday => 1,
  }
}
