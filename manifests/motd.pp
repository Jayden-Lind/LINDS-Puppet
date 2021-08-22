class message_of_day {
  class { 'motd' :
    template => '/etc/puppetlabs/code/environments/production/manifests/motd.epp',
  }
}
