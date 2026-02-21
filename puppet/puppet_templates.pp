
# calling puppet template

$params = {'role' => 'webserver', 'server_name' => 'web01'}

$output = epp('puppet_templates/params_example.epp', $params)


# dynamic file content with puppet template

file { '/tmp/greetings.txt':
  ensure  => file,
  content => $output,
}

# or directly with epp function

file { '/tmp/greetings.txt':
  ensure  => file,
  content => epp('puppet_templates/greetings.epp', $params),
}

# or with inline parameters

file { '/tmp/greetings.txt':
  ensure  => file,
  content => epp('puppet_templates/greetings.epp', {'role' => 'webserver', 'server_name' => 'web01'}),
}
