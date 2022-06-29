class kubernetes {
  require docker

  $repo = "[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
exclude=kubelet kubeadm kubectl"

  $repopath = '/etc/yum.repos.d/kubernetes.repo'

  file { 'kubernetes repo':
    path    => $repopath,
    content => $repo,
  }
  package { 'kubelet':
    ensure          => latest,
    install_options => '--disableexcludes=kubernetes',
  }
  package { 'kubeadm':
    ensure          => latest,
    install_options => '--disableexcludes=kubernetes',
  }
  package { 'kubectl':
    ensure          => latest,
    install_options => '--disableexcludes=kubernetes',
  }
  service { 'kubelet':
    ensure => running,
  }
  exec { 'disable swap':
    path    => ['/usr/sbin/', '/usr/bin', '/bin', '/sbin'],
    command => 'swapoff -a',
    unless  => "awk '{ if (NR > 1) exit 1}' /proc/swaps",
  }
  file_line { 'remove swap in /etc/fstab':
    ensure            => absent,
    path              => '/etc/fstab',
    match             => '\sswap\s',
    match_for_absence => true,
    multiple          => true,
  }
  file { '/etc/containerd/config.toml':
    ensure => absent,
  }
}
