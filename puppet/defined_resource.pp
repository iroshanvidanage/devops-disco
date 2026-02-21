
# Apache Virtual Host defined resource type
# the file name should be vhost.pp

define apache::vhost (
  Variant[String, Integer] $port = 80,
  String $docroot = "/var/www/${title}",
) {
  file { $docroot:
    ensure => directory,
  }

  file { "/etc/httpd/conf.d/${title}.conf":
    ensure  => file,
    content => epp('apache/vhost.epp', { 'title' => $title, 'port' => $port, 'docroot' => $docroot }),
    notify  => Service['httpd'],
  }

  file { "${docroot}/index.html":
    ensure  => file,
    content => "Welcome to ${title}!",
  }

  apache::enable { $title: }
}

define apache::enable (
) {
  exec { "enable_${title}":
    command => "/usr/sbin/a2ensite ${title}.conf",
    unless  => "/usr/sbin/a2query -s ${title}",
    notify  => Service['httpd'],
  }
}


# declaring a defined resource
apache::vhost { 'example.com':
  port    => 80,
}

apache::vhost { 'test.com':
  port    => 8080,
}

apache::vhost { 'myapp.local':
  port    => 80,
}
