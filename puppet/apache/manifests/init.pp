# base class for apache
class apache {

  $packge_name = $facts['os']['family'] ? {
    'RedHat' => 'httpd',
    'Debian' => 'apache2',
    default  => 'httpd',
  }

  $service_name = $facts['os']['family'] ? {
    'RedHat' => 'httpd',
    'Debian' => 'apache2',
    default  => 'httpd',
  }

  package { $packge_name:
    ensure => installed,
  }

  file { '/etc/httpd/conf/httpd.conf':
    ensure  => file,
    source  => 'puppet:///modules/apache/httpd.conf',
    require => Package[$packge_name],
  }

  service { $service_name:
    ensure => running,
    enable => true,
    subscribe => File['/etc/httpd/conf/httpd.conf'],
  }

  file { '/var/www/html':
    ensure  => directory,
  }

}
