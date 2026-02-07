# resource ordering test
notify { 'a': }
notify { 'b': }
notify { 'c': }


# require parameter
package { 'foo':
  ensure => installed,
}

service { 'foo':
  ensure => running,
  require => Package['foo'],
}

# before parameter
package { 'bar':
  ensure => installed,
  before => Service['bar'],
}

service { 'bar':
  ensure => running,
}
