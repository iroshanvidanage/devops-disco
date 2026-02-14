
$username = 'micky'

unless $username =~ String[4, 8] {
  fail('Username must be a string')
}
else {
  notice("Hello ${username}")
}

$bar = $foo ? {
  String => 'foo is a string',
  Integer => 'foo is an integer',
  default => 'foo is something else',
}
