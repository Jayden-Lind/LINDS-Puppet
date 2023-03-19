class kubernetes (
  Boolean $master_node = false,
) {
  $token = lookup('kubeadm_token')
  if $master_node == true {
    exec { 'kubeadm init':
      command   => "kubeadm init --pod-network-cidr 10.244.0.0/16 --token ${token} --token-ttl 0",
      path      => ['/usr/bin', '/usr/sbin', '/bin', '/sbin', '/usr/local/bin'],
      unless    => "kubectl get nodes | grep -i ${$facts['networking']['hostname']}",
      user      => 'root',
      logoutput => true,
    }
    vcsrepo { "/root/LINDS-Kubernetes":
      ensure   => present,
      provider => git,
      source   => 'https://github.com/Jayden-Lind/LINDS-Kubernetes',
    }
  }

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
    install_options => ['--disableexcludes=kubernetes', '--nobest'],
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
  file { '/etc/containers/policy.json':
    path    => '/etc/containers/policy.json',
    owner   => root,
    group   => root,
    mode    => '0644',
    content => file('/etc/puppetlabs/code/environments/production/resources/policy.json'),
  }
  file { '/mnt/data':
    ensure => 'directory',
    owner  => root,
    group  => root,
    mode   => '0644',
  }
  if $facts['networking']['hostname'] =~ /^LINDS-.*/ {
    file { '/mnt/nas':
      ensure => 'directory',
      owner  => root,
      group  => root,
      mode   => '0644',
    }
    class { 'nfs':
      nfs_server     => 'jd-truenas-01.linds.com.au',
      nfs_extra_path => '/mnt/NAS/NAS',
      mount_path     => '/mnt/nas',
    }
    if $facts['networking']['hostname'] =~ /^LINDS-Kube-02.*/ {
      cron { 'scp /mnt/data to NAS':
        command => 'cp -r /mnt/data/ /mnt/nas/',
        user    => 'root',
        minute  => '0',
        hour    => '2',
        weekday => '1',
      }
    }
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

  exec { 'kubeadm join':
    command     => "kubeadm join 10.0.53.10:6443 --token ${token} --discovery-token-ca-cert-hash sha256:e43e13da9608cd5bf50464978a0c1257858aaadc87f9c0ff4cc5a516100718d7",
    path        => ['/usr/bin', '/usr/sbin', '/bin', '/sbin', '/usr/local/bin'],
    environment => ['HOME=/root', 'KUBECONFIG=/etc/kubernetes/kubelet.conf'],
    logoutput   => true,
    timeout     => 0,
    user        => 'root',
    unless      => 'test -f /etc/kubernetes/kubelet.conf',
  }
}
