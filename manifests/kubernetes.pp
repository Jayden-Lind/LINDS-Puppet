class kubernetes {
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
  file { 'cri-o repo':
    path    => '/etc/yum.repos.d/devel_cri_1.24.repo',
    content => '[devel_kubic_libcontainers_stable_cri-o_1.24]
name=devel:kubic:libcontainers:stable:cri-o:1.24 (CentOS_8)
type=rpm-md
baseurl=https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable:/cri-o:/1.24/CentOS_8/
gpgcheck=1
gpgkey=https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable:/cri-o:/1.24/CentOS_8/repodata/repomd.xml.key
enabled=1',
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
  package { 'cri-o':
    ensure => latest,
  }
  service { 'crio':
    ensure => running,
    enable => true,
  }
  service { 'kubelet':
    ensure => running,
    enable => true,
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
  exec { 'enable ip forward':
    path    => ['/usr/sbin/', '/usr/bin', '/bin', '/sbin'],
    command => 'echo 1 > /proc/sys/net/ipv4/ip_forward',
    unless  => 'grep 1 /proc/sys/net/ipv4/ip_forward',
  }
  exec { 'enable br filter':
    path    => ['/usr/sbin/', '/usr/bin', '/bin', '/sbin'],
    command => 'modprobe br_netfilter',
    unless  => 'grep 1 /proc/sys/net/bridge/bridge-nf-call-iptables',
  }
  exec { 'kube autocomplete':
    path    => ['/usr/sbin/', '/usr/bin', '/bin', '/sbin'],
    command => 'kubectl completion bash | sudo tee /etc/bash_completion.d/kubectl > /dev/null',
    unless  => 'test -f /etc/bash_completion.d/kubectl',
  }
  file_line { 'add KUBECONFIG to env':
    ensure => present,
    path   => '/root/.bashrc',
    match  => '^export KUBECONFIG',
    line   => 'export KUBECONFIG=/etc/kubernetes/admin.conf',
  }
  file { '/mnt/data':
    ensure => 'directory',
    owner  => root,
    group  => root,
    mode   => '0644',
  }
  file { '/opt/bin':
    ensure => 'directory',
    owner  => root,
    group  => root,
    mode   => '0644',
  }
  file { 'flanneld':
    ensure => 'file',
    path   => '/opt/bin/flanneld',
    mode   => 'a+x',
    source => 'https://github.com/flannel-io/flannel/releases/latest/download/flanneld-amd64',
  }
}
