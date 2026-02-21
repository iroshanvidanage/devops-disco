
# dynamic attributes example

$attr = {
  ensure => file,
  owner  => 'root',
  group  => 'root',
  mode   => '0644',
}

file {
  default:
    * => $attr;

  '/etc/foo':
    source => 'puppet:///modules/foo';
  '/etc/bar':
    source => 'puppet:///modules/bar';
  '/etc/tango':
    source => 'puppet:///modules/tango',
    group  => 'wheel'; # this will override the default group for this resource only
}
