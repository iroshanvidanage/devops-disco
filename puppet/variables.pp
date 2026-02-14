
# variables

$pkgname = 'httpd'
$userid = '9999'
$username = 'bob'
$firstname = 'Bob'
$lastname = 'Smith'
$comment = "${firstname} ${lastname}"

package { $pkgname:
  ensure => installed,
}

user { $username:
  ensure => present,
  uid    => $userid,
  comment => $comment,
}

