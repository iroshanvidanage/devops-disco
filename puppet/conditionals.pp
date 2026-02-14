# Conditionals

#  Selectors
$packge_name = $::facts['os']['family'] ? {
    'RedHat'  => 'httpd',
    'Debian'  => 'apache2',
    'Solaris' => 'CSWApache2',
    default   => 'httpd',
  }


# Case statements
case $::facts['os']['family'] {
  'RedHat': {
    include yum
    include apache::redhat
    $packge_name = 'httpd'
  }
  'Debian': {
    include apt
    include apache::debian
    $packge_name = 'apache2'
  }
  'Solaris': {
    include solaris
    include apache::solaris
    $packge_name = 'CSWApache2'
  }
  default: {
    fail ("Unsupported operating system family: ${::facts['os']['family']}")
  }
}


# Regular expressions
case $::trusted['certname'] {
  /.*\.uk\..*/ : {
    include users::london
  }
  /.*\.es\..*/ : {
    include users::madrid
  }
  default: {
    fail ("No specific configuration for ${::trusted['certname']}")
  }
}

$country = $::trusted['certname'] ? {
  /.*\.uk\..*/ => 'UK',
  /.*\.es\..*/ => 'Spain',
  default      => 'Unknown',
}


# If else statements

if $install_package {
  package { $packge_name:
    ensure => installed,
  }
}

if $environment == 'dev' {
  include devutils
}

if $environment != 'prod' {
  include devutils
}
unless $environment == 'prod' {
  include devutils
}
