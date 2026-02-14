# base class for apache
class apache {

  package { 'httpd':
    ensure => installed,
  }

  file { '/etc/httpd/conf/httpd.conf':
    ensure  => file,
    source  => 'puppet:///modules/apache/httpd.conf',
    require => Package['httpd'],
  }

  service { 'httpd':
    ensure => running,
    enable => true,
    subscribe => File['/etc/httpd/conf/httpd.conf'],
  }

  file { '/var/www/html':
    ensure  => directory,
  }

}
