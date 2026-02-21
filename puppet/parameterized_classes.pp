
# normal class

class apache {
  $version = '2.4'
  $docroot = '/var/www/html'
  $bindaddress = '10.0.1.15'
  $port = '80'

  package { 'httpd':
    ensure => $version,
  }

  $params = { 'docroot' => $docroot, 'bindaddress' => $bindaddress, 'port' => $port }

  file { '/etc/httpd/conf/httpd.conf':
    ensure  => file,
    content => template('apache/httpd.conf.epp', $params),
    require => Package['httpd'],
  }
}


# parameterized class

class apache (
  $version,
  $docroot,
  $bindaddress,
  $port
) {

  package { 'httpd':
    ensure => $version,
  }

  $params = { 'docroot' => $docroot, 'bindaddress' => $bindaddress, 'port' => $port }

  file { '/etc/httpd/conf/httpd.conf':
    ensure  => file,
    content => template('apache/httpd.conf.epp', $params),
    require => Package['httpd'],
  }
}


# parameterized class with default values and validation

class apache (
  String $version = '2.4',
  String $docroot = '/var/www/html',
  String $bindaddress,
  Integer $port = 80
) { ... }


# class declaration with parameters

class { 'apache':
  bindaddress => '10.0.1.15',
  port        => '80',
  docroot     => '/var/www/html',
  version     => '2.4',
}
