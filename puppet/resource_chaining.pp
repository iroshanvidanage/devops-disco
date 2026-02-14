
# Resource chaining
# chaining arrows
Notify ['d'] -> Notify ['e'] -> Notify ['f']

# chaining direclty between resources
# this is avoided because of the readablity, but it is possible
package { 'foo':
  ensure => installed,
} -> service { 'foo':
  ensure => running,
}

# chaining with multiple resources
package { 'bar':
  ensure => installed,
} -> Service['bar', 'baz']

service { 'bar':
  ensure => running,
}

service { 'baz':
  ensure => running,
}

# chaining with multiple resources on both sides
Package['foo', 'bar'] -> Service['foo', 'bar']

# chaining with multiple resources on both sides and chaining arrows
Package['foo', 'bar'] -> notify { 'a': } -> Service['foo', 'bar']

# refreshing chains
# this is the same as the previous example, but with a refresh instead of a require
Package['httpd'] -> File [ '/etc/httpd/httpd.conf'] ~> Service['httpd']

Service['httpd'] <~ File [ '/etc/httpd/httpd.conf'] <- Package['httpd']
