
class apache::params {
  $package_name = $facts['os']['family'] ? {
    'RedHat' => 'httpd',
    'Debian' => 'apache2',
    default  => 'httpd',
  }
  $service_name = $facts['os']['family'] ? {
    'RedHat' => 'httpd',
    'Debian' => 'apache2',
    default  => 'httpd',
  }
}

class apache (
  String $package_name = $apache::params::package_name,
  String $service_name = $apache::params::service_name,
) inherits apache::params {
  package { $package_name:
    ensure => installed,
  }

  service { $service_name:
    ensure => running,
    enable => true,
  }
}
