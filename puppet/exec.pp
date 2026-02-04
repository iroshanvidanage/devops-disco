
exec { 'run_command':
  command => '/path/to/your/command',
  path    => ['/usr/bin', '/bin'], # Optional: specify the PATH for the command
  unless  => 'test -f /path/to/some/file', # Optional: only run if this condition is not met
  onlyif   => 'test -f /path/to/another/file', # Optional: only run if this condition is met
}

exec { 'run_script':
  command => '/path/to/your/script.sh',
  path    => ['/usr/bin', '/bin'], # Optional: specify the PATH for the script
  creates => '/path/to/created/file',
  require => Exec['run_command'], # Optional: ensure this runs after 'run_command'}
}
