
class hostname {

  $server_name = 'appserver-p-01a'

  $env_name = hostname::environment($server_name)

  notify { "The environment for ${server_name} is ${env_name}": }
}

# puppet apply -e "include hostname"
