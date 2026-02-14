
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
