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

# static file resource with content defined directly in the manifest
file { '/opt/motd/start.html':
  ensure  => file,
  owner   => 'root',
  group   => 'root',
  mode    => '0644',
  content => 'Welcome to system administration with Puppet!',
}
