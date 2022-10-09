class terraform {
  $user = 'root'
  yumrepo { 'hashicorp':
    enabled  => 1,
    descr    => 'Hashicorp Stable - $basearch',
    baseurl  => 'https://rpm.releases.hashicorp.com/RHEL/$releasever/$basearch/stable',
    gpgcheck => 1,
    gpgkey   => 'https://rpm.releases.hashicorp.com/gpg',
  }
  package { 'terraform':
    ensure => latest,
  }
  package { 'packer':
    ensure => latest,
  }
  package { 'mkisofs':
    ensure => latest,
  }
  file_line { 'Terraform autocomplete':
    ensure => present,
    path   => "/${user}/.bashrc",
    match  => '^complete -C /usr/bin/terraform',
    line   => 'complete -C /usr/bin/terraform terraform',
  }
  file_line { 'Packer Path':
    ensure => present,
    path   => "/${user}/.bashrc",
    match  => '^export PATH',
    line   => 'export PATH=/usr/bin:$PATH',
  }
  file { '/mnt/NAS':
    ensure => 'directory',
    owner  => root,
    group  => root,
    mode   => '0644',
  }
}
