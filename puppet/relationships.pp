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

# subscribe parameter
file { '/etc/httpd/httpd.conf':
  ensure  => file,
  content => 'puppet:///modules/apache/httpd.conf',
}

service { 'httpd':
  ensure    => running,
  subscribe => File['/etc/httpd/httpd.conf'],
}

# notify parameter
file { '/etc/my.cnf':
  ensure  => file,
  content => 'puppet:///modules/mysql/my.cnf',
  notify  => Service['mysqld'],
}

service { 'mysqld':
  ensure => running,
}

# Exec resource with refreshonly
service { 'tinpot':
  ensure => running,
  enable => true,
  notify => Exec['clear_tinpot_cache'],
}

exec { 'clear_tinpot_cache':
  path        => '/opt/tinpot/bin',
  command     => 'tinpot --clear-cache',
  refreshonly => true,
}

