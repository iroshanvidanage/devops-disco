
# assignement functions

$email = "dude@example.com"

$username = match($email, /^([a-z]+)\@.*$/)
$username = $email.match(/^([a-z]+)\@.*$/)

# lambda functions/code blocks
# Chained
$variable.function | $parameter | {
  # code block
}

# Prefixed
function($variable) | $parameter | {
  # code block
}

# Example of a lambda function
$user = with("susan", "susan@example.com") | $name, $email | {
  { 'name' => $name, 'email' => $email }
}


# loops & iterators
# each
$vhosts = ['example.com', 'test.com', 'demo.com']
$vhosts.each | $host | {
  file { ["/etc/apache2/sites-available/${host}.conf", "/etc/apache2/sites-enabled/${host}.conf"]:
    ensure => file,
    content => template('apache/vhost.conf.erb'),
  }
}

$vhosts.each | $hostname, $spot | {
  ...
}
