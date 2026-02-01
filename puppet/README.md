# Puppet

## Requirements

- Use the Vagrantfile to spin up two VMs.

## Puppet RAL

- `puppet resource` command can be used to interact with the puppet RAL (Resource Abstraction Layer)
- `puppet resource user bob` gives the current state of the user bob in the system.
- `puppet resource user bob ensure=present` will create the user if the user is not found in the system.

- `puppet describe` command will give you the attributes of a particular resource type.
- `puppet describe user | more` gives the attributes documentation of the `user` resource.
- With more attributes we can customize the resource creation as we required.
- `puppet resource user bob ensure=present uid=9999`

- `puppet describe --list` would give all the resource types available.
- `grep sysadmins /etc/group`
- `grep bob /etc/passwd`


## Puppet DSL

- Puppet DSL is a declarative language.
- Resource declaration has three parts:
    - Resource type
    - Name of the resource
    - Attributes
```puppet
type { 'title':
    attribute => 'value',
    attribute => 'value',
    attribute => 'value',
}

user { 'bob':
    ensure => present,
    uid => '9999',
    groups => 'sysadmins',
}

```

- Resource declarations are written in manifests files with `.pp` extension.
- `puppet apply` is used to apply a manifest.
- Resource must be unique, cannot define two states for the same resource.
- [bob.pp](bob.pp)


## Classes

- Classes provide re-usable configuration models.
- Singleton.
- Model configuration by grouping together resources.
- `puppet apply -e 'include sysadmins'` in order to classes to be included they need to be inside a module.


## Modules

- A module has all the classes associated with it's configuration model.
- Modules contain:
    - File serving
    - Puppet extensions
- Modules follow a specific filesystem layout called podulepath.
- `puppet config print` helps to find the current modulepath.
- A module is installed in `<modulepath>/<modulename>`
- Classes are stored in a folder called `manifests/`.
- The base class for the module is named as the module name and sits in a file called `init.pp`.


## Server & Agent

### Agent

- The agent is installed in all of the nodes. Runs as a daemon checking in periodically (30minutes).
- We can trigger one off puppet run using `puppet agent -t`
    - `-o --onetime` Run once and exit
    - `-n --nodaemonize` Run in the foreground
    - `-v --verbose` Run in verbose mode
    - `-t --test` Implies `-onv`
    - `--noop` Compare catalog but don't apply any changes.

### Authentication

- Agent connects to server over authenticated SSL.
- Retrieves and applies configuration.

### SSL

- Puppet server is a certificate authority (CA).
- The agent generates an SSL signing request (CSR) and sends it to the server.
- The server signs and returns the cert to the agent.
- Puppet uses the certname to identify hosts.
- Agent verifies the server SSL cert contains the certname.
- We can use the `puppet cert` command to manage certificates.



