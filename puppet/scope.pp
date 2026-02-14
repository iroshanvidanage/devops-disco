
# variable scopes

$var = 1

class foo {
  $var = 2
}


class bar {
  $var = 3

  notify { "in top: ${::var}": }
  notify { "in foo: ${::foo::var}": }
  notify { "in bar: ${var}": }
}


# facts as variables

notify { "osfamily is ${::facts['os']['family']}": }


# trusted facts
notify { "trusted['certname'] is ${::trusted['certname']}": }
