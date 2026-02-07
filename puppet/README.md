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
- `puppet module list` shos the modules and the paths they live in.


## Server & Agent

- Generally the puppet server is named as `puppet.<domain>` and the agents are named as `agent{$id}.<domain>`.
- The DNS resolution will help to identify the puppet master.

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


### Comfiguring Puppet Server

- The puppet server configs are located in `/etc/sysconfig` dir in file `puppetserver`

> [!Note]
> Edit the memory requirements as needed.

- Start the puppet server `systemctl start puppetserver`

- `puppet cert --list` lists the pending unsigned certificates
- `puppet cert --list --all` lists all the certificates
    - `+` sign shows the certificate has been signed.
- `puppet cert --sign <certname>` signs the certificate
- `puppet cert --print <certname> | more` prints the certificate


### Configuring Puppet Agent

- A new server which has puppet agent needs to be authenticated to the puppet server.
- The agent looks up the following config files for details related to Puppet server (master)
    - Config files `/etc/puppetlabs/puppet/puppet.conf` or `/etc/puppet/puppet.conf`
    - DNS lookup for `puppet.mydomain.com`
    - Env variable `PUPPET_SERVER`
    - CLI argument `--server` it will override the default settings and directly specify the Puppet server's address.
    - Hostname resolution in local DNS `/etc/hosts`
- The hostname entry is similar to `192.168.1.100   puppet.mydomain.com puppet`
- The `puppet agent -t` will initialize the puppet agent authentication.
- In the puppet agent initial start, the agent creates a CSR file and sends to the puppetserver and once the certfile is signed it will be retrieved in the next `puppet agent -t` and will be added to the agent cache.


### Common SSL Issues

- Clocks out of sync. Running NTP is advised.
- Certname mismatch between servers and agents.
- Agent has been rebuilt.
- To overcome SSL issues, old certs must be removed from both the agent and the server.
- `puppet cert clean <certname>` removes the certs in the puppet server.
- To remove puppet agent cert:
    - `puppet config print ssldir` shows the ssl cert directory: default `/etc/puppetlabs/puppet/ssl`.
    - `rm -rf *` removes everything from the directory.
- Now reinitialize the agent.


### Facter

- Facter gathers a wide variety of information about the agent mnode.
- Puppet can use these facts to determine how to configure resources.
- Easily extendable to add your own facts.
- Puppet agent sends facts to the server on every run.
- We can use the command `facter` to view them `facter | more`.
- `facter --help | more` view the attributes and flags.
    - `facter operatingsystem`
    - `facter osfamily`
    - `facter hypervisors`
    - `facter identity`
    - `facter memory`


### A Puppet Run

1. Initially the SSL authentication.
2. The Agent machine gathers the facts and sends to the Puppet Server (master).
3. The Puppet server sends all the resources in the [Catalog](#catalog) to the Agent against the running state of the system and with RAL enforces changes when necessary.
4. The Agent sends a detailed report back to the Server with all the changes that have been made.


### Catalog

- The Puppet master compile all the resources defined in manifests in to the Catalog.
- Contains all managed resources and the state they should be in.
- Puppet agent uses the RAL to compare Running State to catalog (Desired State).
- Changes are enforces where drift is detected.


### Classification

- When an Agent authenticated with the Server the Agent is being classified.
- It means that the Server identifies which classes should be applied to the Agent.
- Then the Catalog is compiled.
- Puppet classifies in two ways.
- External node classifier (ENC) used in prod envs.
    - Enterprise Console: ships with Puppet enterprise.
    - Foreman: open source tool.
- When an Agent request comes to the Server, the Puppet master will query the ENC and finds out what classes should be applied to that particular node.
- Manifest file based classification (site.pp): The mose simple and lightweight form of classification.


### Manifest based Classification

- Puppet automatically reads in a manifest file called `site.pp`.
- This can be find out by using `puppet config` command in the manifest directory.
    - `/etc/puppetlabs/code/environments/production/manifests/site.pp`
- Within the `site.pp` we can use [node definitions](#node-definition) to specify this classification.


### Node Definition

- The node definition is as follows.
- We have the `node` keyword, followed by the cert name of the node, and in between brackets we can include any Puppet code we need to.
- It's recommended only to use a node definition to include classes, not to include any node-level logic.
- [`site.pp`](./site.pp)
- `puppet config 


### Apply puppet classes to nodes.

- To apply any changes to local Puppet Server; `puppet apply -e 'include sysadmins'` execute in the Puppet Server.
- To applu to Agent node we need to classify the class to the Agent node in `site.pp`.
- `puppet config print manifest` should shows the Puppet Server would search for manifests.
    - `/etc/puppetlabs/code/environments/production/manifests` default location.



## The Puppet Language


### More Resources

- [Package](packages.pp) : Ensure absent, installed latest or a specific version.
- [Service](services.pp) : Ensure can be `running` or `stopped`.
    - Enable makes the service start at boot time and can be `true` or `false`.
    - Some applications have non-standard services.
    - We can override behaviour using the following attributes.
        - `restart`, `stop`, `start`, `status`
- Notify : Non impacting resource type that causes a notice message to be displayed.
```puppet
notify { 'Hello World!':}
```
- [Exec](exec.pp) : Execute any arbitrary command.
    - Not a replacement for a type and provider.
    - Use sparingly.
    - It's not a replacement for a proper type and provider.
    - Not idempotent by default.
    - Can be made idempotent by using `creates`, `onlyif` or `unless`
- [Namevar](namevars_examples.pp) : Puppet resources must be unique, normally the title of the resource is used as the unique identifier.
    - Each resource type also has one or more attributes that are `namevars`.
    - Resource titles and namevars must be unique.


### Puppet describe

- To view list of available resources `puppet describe --list`
- To view the configurable attributes of a resource type `puppet describe <resource type>`


## File Serving

### File resource type

- Manage files, directories and symlinks.
- `ensure` can be `file`, symlink or directory.
- `owner`, `group` and `mode` can be used to configure file properties.
- We can manage content statically or dynamically.
- `source` specifies a location on the puppet server to serve the file statically.
- `content` specifies a string value to populate the file.
- [files.pp](files.pp)


#### Static Files
- For static files the source should be as following:
- `puppet://<hostname>/<mountpoint>/<path>` `hostname` is specified.
- `puppet:///<mountpoint>/<path>` `hostname` is not specified, the content will be taken from the puppet server currently in use for the session.
- The `mountpoint` by default corresponds to an entry in `fileserver.conf`
```ini
puppet:///archives/application.jar

[archives]
    path /srv/puppet/archives
    allow *
```

`archives` -> `/srv/puppet/archives`

- The `modules` mountpoint is a special internal mountpoint.
- The server will search in a predetermined location in the `modulepath`.
- The path ised for the modules mountpoint is `<modulename>/<filename>`
- The filename is relative from the files directory in:
    - `<modulename>/files/<filename>` <- `apache/files/httpd.conf`
    - `puppet:///modules/apache/httpd.conf`
    - The filename is looked up within the modules sub dir called `files`.
    - `<path>` is actually made up of the `modulename` and `filename` combined.
- To stop replacing the content of the file if the content has been changed, use `replace: false`
