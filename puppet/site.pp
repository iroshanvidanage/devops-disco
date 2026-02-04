# Node definitions for Puppet

node 'webserver.example.com' {
  include apache
  include php
}

node 'dbserver.example.com' {
  include mysql
  include backup
}

# This node definition applies to all nodes in the enviatics.com domain
node /*.enviatics.com/ {
  include enviatics_config
}

# Default node definition for any nodes that do not match the above patterns
node default {
  include base_config
}
