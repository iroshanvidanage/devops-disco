# group and user resources with an implied dependency
user { 'bob':
  ensure => present,
  groups => 'sysadmins',
}

group { 'sysadmins':
  ensure => present,
}

# file resource with an implied dependency on the parent directory
file { '/etc/puppet/puppet.conf':
  ensure  => file,
  content => 'puppet.conf content',
}

directory { '/etc/puppet':
  ensure => directory,
}

# file resource with an implied dependency on the parent directory and owner
file { '/etc/puppet/puppet.conf':
  ensure => file,
  owner  => 'bob',
}
