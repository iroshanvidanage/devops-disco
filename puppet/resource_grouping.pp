
file { '/etc/foo':
  ensure => file,
  source => 'puppet:///modules/foo',
}

file { '/etc/bar':
  ensure => file,
  source => 'puppet:///modules/bar',
}

file { '/etc/tango':
  ensure => file,
  source => 'puppet:///modules/tango',
}


# this can be written as:

file {
  '/etc/foo':
    source => 'puppet:///modules/foo';
  '/etc/bar':
    source => 'puppet:///modules/bar';
  '/etc/tango':
    source => 'puppet:///modules/tango';
}
