
# resource defaults using references

File {
  ensure => file,
  owner  => 'root',
  group  => 'root',
  mode   => '0644',
}

# include apache

file {
  '/etc/foo':
    source => 'puppet:///modules/foo';
  '/etc/bar':
    source => 'puppet:///modules/bar';
  '/etc/tango':
    source => 'puppet:///modules/tango';
}

# This will create the same resources as the previous example, but with less code and more configurations.

# but there's a catch, if you include a class and that class has a file resource the same defaults will be applied to that resource as well, which may not be what you want. In that case you can use the 'default' keyword to specify that the defaults should only apply to resources.
# This is due to the File defaults are applied to the current scope and the class is included in the same scope now.

# to avoid this you can use the 'default' keyword to specify that the defaults should only apply to resources.

# resource defaults in resource declarations

file {
  default:
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0644';

  '/etc/foo':
    source => 'puppet:///modules/foo';
  '/etc/bar':
    source => 'puppet:///modules/bar';
  '/etc/tango':
    source => 'puppet:///modules/tango',
    group  => 'wheel'; # this will override the default group for this resource only
}
