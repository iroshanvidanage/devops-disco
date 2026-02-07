
package { 'nginx':
  ensure => installed,
}

# in here the resource that's beeing installed is nginx but the resource title is web_server within puppet
# if the name attribute is present the command used to install the package will be 'nginx' instead of 'web_server' because the name attribute is the namevar for the package resource type
package { 'web_server':
  ensure => installed,
  name   => 'nginx', # the namevar attribute for package resource type is 'name'
}

# if this is declared again it will throw an error because the resource title 'nginx' is already declared
# package { 'nginx':
#   ensure => installed,
# }

# here it is being declare the same resource with a different title but the same namevar value, but the puppet uniquness will act on the name attribute and since the name 'nginx' is already declared previously an error will be thrown.
package { 'web_server_2':
  ensure => installed,
  name   => 'nginx',
}

# exceptions
# there are some resources which are distributed under different providers;
# here we have specified the provider to be 'gem'
package { 'mysql':
  ensure   => installed,
  provider => 'gem',
}

# in the second declaration the default package manager is selected from RAL depending on the os of the system, therefore the provider is not specified and the package will be installed using the default provider for that system, which could be 'rpm' for RedHat based systems or 'deb' for Debian based systems.
package { 'rpm-mysql':
  ensure   => installed,
  provider => 'mysql',
}
# in this set the uniqueness is a combination of title, provider and the namevar. which is different for the both.
