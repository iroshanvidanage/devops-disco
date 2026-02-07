# static file resources
file { '/etc/httpd/httpd.conf':
  ensure => file,
  owner  => 'root',
  group  => 'root',
  mode   => '0644',
  source => 'puppet:///modules/apache/httpd.conf',
}

# dynamic file resource using a template
file { '/etc/httpd/conf.d/vhosts.conf':
  ensure  => file,
  owner   => 'root',
  group   => 'root',
  mode    => '0644',
  content => template('apache/vhosts.conf.erb'),
}

# dynamic file resource with content defined directly in the manifest
file { '/opt/motd/start.html':
  ensure  => file,
  owner   => 'root',
  group   => 'root',
  mode    => '0644',
  content => 'Welcome to system administration with Puppet!',
}

# static file resource without replacing existing content
file { '/etc/motd':
  ensure  => file,
  owner   => 'root',
  group   => 'root',
  mode    => '0644',
  source  => 'puppet:///modules/motd/motd.txt',
  replace => false,
}

# directory resource with recursive content management
file { '/var/www/html':
  ensure  => directory,
  owner   => 'apache',
  group   => 'apache',
  mode    => '0755',
  recurse => true,
  source  => 'puppet:///modules/apache/html/',
}

# symbolic link resource
file { '/var/www/html/latest':
  ensure => symlink,
  target => '/var/www/html/releases/release-2024-06-01',
  owner  => 'apache',
  group  => 'apache',
}
