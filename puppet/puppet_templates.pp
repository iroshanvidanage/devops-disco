
# calling puppet template

$params = {'role' => 'webserver', 'server_name' => 'web01'}

$output = epp('puppet_templates/params_example.epp', $params)
