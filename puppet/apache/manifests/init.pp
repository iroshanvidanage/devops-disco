# base class for apache
class apache {

# In this case it's better to use case statements instead of selectors because we have multiple variables to set based on the same fact
# Using selectors would require repeating the same logic for each variable, which can lead to code duplication and make it harder to maintain.

  # $packge_name = $::facts['os']['family'] ? {
  #   'RedHat' => 'httpd',
  #   'Debian' => 'apache2',
  #   default  => 'httpd',
  # }

  # $service_name = $::facts['os']['family'] ? {
  #   'RedHat' => 'httpd',
  #   'Debian' => 'apache2',
  #   default  => 'httpd',
  # }

  # $file_path = $::facts['os']['family'] ? {
  #   'RedHat' => '/etc/httpd/conf/httpd.conf',
  #   'Debian' => '/etc/apache2/apache2.conf',
  #   default  => '/etc/httpd/conf/httpd.conf',
  # }

  case $::facts['os']['family'] {
    'RedHat': {
      $packge_name = 'httpd'
      $service_name = 'httpd'
      $file_path = '/etc/httpd/conf/httpd.conf'
    }
    'Debian': {
      $packge_name = 'apache2'
      $service_name = 'apache2'
      $file_path = '/etc/apache2/apache2.conf'
    }
    default: {
      fail ("Unsupported operating system family: ${::facts['os']['family']}")
    }
  }

  package { $packge_name:
    ensure => installed,
  }

  file { $$file_path:
    ensure  => file,
    source  => 'puppet:///modules/apache/httpd.conf',
    require => Package[$packge_name],
  }

  service { $service_name:
    ensure => running,
    enable => true,
    subscribe => File[$file_path],
  }

  file { '/var/www/html':
    ensure  => directory,
  }

}
