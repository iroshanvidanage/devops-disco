# 

service { 'sshd':
  ensure  => running,
  enable  => true,
  require => Package['openssh-server'],
}

service { 'httpd':
  ensure => running,
  enable => true,
  status => '/etc/systemd/system/httpd status',
  start  => '/etc/systemd/system/httpd start',
  stop   => '/etc/systemd/system/httpd stop',
}

service { 'tinpot':
  ensure => running,
  enable => true,
  status => '/opt//tinpot/bin/status.sh',
  start  => '/etc/tinpot/bin/server --start',
  stop   => '/etc/tinpot/bin/server --stop',
}
