
# arrays

$users = [ 'bob', 'susan', 'peter' ]
$groups = [ 'sysadmin', 'dbas', 'dev' ]


user { $users:
    ensure => present,
    groups => $groups,
}

user { 'alice':
    ensure => present,
    groups => [ 'sysadmin', 'dbas', 'dev' ],
}

# resource reference with array
file { '/etc/app.conf':
    ensure  => file,
    require => Package['httpd', 'acmeapp'],
}

file { '/etc/web.conf':
    ensure  => file,
    require => [ Package['httpd'], Service['acmed'] ],
}


# reference an array element by index
$user = $users[0]
