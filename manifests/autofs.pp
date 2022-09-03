class auto_fs_nas (
  String $nas_server,
  String $mount_path,
  String $mount_dir,
  String $extra_path = ''
) {

  include autofs
  $username = lookup('smb_username')
  $password = lookup('smb_password')
  if $facts['os']['distro']['release']['major'] == '7' {
    $ver = '3'
  }
  if $facts['os']['distro']['release']['major'] == '8' {
    $ver = '3.1.1'
  }
  if $facts['os']['distro']['release']['major'] == '9' {
    $ver = '3.1.1'
  }
  autofs::mount { 'nas':
    mount   => $mount_path,
    mapfile => '/etc/auto.smbnas',
    options => '--timeout=180 --ghost',
  }
  autofs::mapfile { 'nas':
    path     => '/etc/auto.smbnas',
    mappings => [
      {
        'key'     => $mount_dir,
        'options' => "-fstype=cifs,username=${username},password=${password},domain=linds.com.au,vers=${ver},dir_mode=0777,file_mode=0777,_netdev,cache=none,rsize=8388608,wsize=8388608",
        'fs'      => "://${nas_server}/nas${extra_path}",
      },
    ],
  }
}
