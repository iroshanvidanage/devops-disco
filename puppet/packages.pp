# Installs ntp and httpd packages

package { 'ntp':
  ensure => installed,

  before => Package['httpd'],
}

package { 'httpd':
  ensure => '2.3.3',
}

package { 'openssh-server':
  ensure => installed,
}
