class rhel {
  package { 'tuned':
    ensure => latest,
  }
  service { 'tuned':
    ensure => running,
    enable => true,
  }
}
