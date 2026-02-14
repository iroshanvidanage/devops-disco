
# hashes

$uids = {
  'susan' => '9990',
  'bob'   => '9991',
  'peter' => '9992',
}

# hash lookup
$bob_uid = $uids['bob']
notify { "Bob's UID is ${bob_uid}": }

# Iterate over the hash and create a user resource for each entry
$uids.each |$name, $uid| {
  user { $name:
    ensure => present,
    uid    => $uid,
  }
}
