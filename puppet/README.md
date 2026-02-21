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


## Relationships

### Resource Ordering

- Resources are read in the order they are written.
- That doesn't always mean that's the order they will be applied in.
- Manifest ordering is now default, but explicit relationships are clearer especially with resources across multiple classes.
- The ordering option in `puppet.conf` used to order, defaults to `manifest` in later versions of Puppet, but could be `title-hash` or `random`.
- `puppet config print ordering` shows the ordering method.
- `puppet apply relationship.pp --ordering title-hash` applies according to the hash value of the title.
- `puppet apply relationship.pp --ordering random` applies randomly.


### Resource Referencing

- A resource reference is a pointer to a resource declaration.
- A resource reference always starts with an uppercase letter, in consistance with the resource type followed by the title of the resource.
- To declare relationships between resources, there're a number of meta parameters available.
```puppet
# resource declaration
package { 'httpd':
    ensure => installed,
}

# resource reference
Package['httpd']
```


>[!NOTE]
> When referencing a resource, we are managing the resource declaration in Puppet, not the configured entity on the agent. The resource should be declared in the catalog.
> The resource created in the system - manually doesn't applies to the reference.


#### require/before

- `require` allows to reference a nother resource declaration to be configured before the current.
- In the event of the required reference fails to install or execute, the current resource will be skipped.
- Using `before` is exactly the reverse of the `require` parameter.
- `require` and `before` can be used interchangeably, but it's more readable to use `require`.


### Triggering Events

- Some resources need to take an action based on an event occuring in a different resource.
- For example when a configuration file changed we want to restart the service.
- Some resource types are refreshable, meaning they taken an action when they receive a refresh event.
- As an [example](./relationships.pp/#subscribe-parameter), we need to restart the `httpd` service whenever the Apache configuration file is updated.
- Two meta parameters available for this purpose; `subscribe` or `notify` to send an event notification.
- The addedd benefit of using `subscribe` is that whenever a change is detected for the referenced resource, a service resource will restart the service. Also this will make sure that the file resource is managed before the service resource, similar to `require`.
- The `notify` is the opposite to `subscribe` and similar to `before`, therefore when the ordering is done any resource with `notify` meta parameter is managed before the referenced resource.
- The exec resource is also refreshable. Since an exec resource needs to be idempotent we can use `refreshonly` parameter.


#### Implied Dependencies

- Some resource have implied dependencies, there are times when Puppet knows that certain resources should be configured before other resources.
- You don't always need to specify dependency metaparameters.
- As an example `user` resource type.
- [Examples](implied_dependencies.pp)
- Here the build-in logic of `user` type resource, it ensures that the required groups are created before the user is created, hence if the `group` type is declared, then it will be managed before the `user` is managed.
- So we don't need to explicitly declare that dependency.


#### Resource Chaining

- Puppet also supports a short hand syntax for expressing relationships by referencing the resources and chaining them together.
- When referencing resources, they must be declared.
- `Package['httpd'] -> File['/etc/httpd/httpd.conf']`
- This implies that `Package` resource should be managed before the `File` resource.
- If the resource chaining is added we don't have to add `before` or `require` parameters.
- Resource declarations can also be directly chained.
- [Example](resource_chaining.pp)
    - `->` left before right
    - `<-` right before left
    - `~>` left refreshes right
    - `<~` right refreshes left


## Exercise - Package / File / Service

- This is a design pattern where the package resource is managed first and then any files required are created then the service resource is managed.
- In this exercise a module for apache httpd service will be created.
- Manage the httpd package and service.
- Manage the default httpd.conf file
- Ensure the document root exists.
- Module path: `/etc/puppetlabs/code/environments/production/modules/`
- Module directory tree: [apache](./apache/manifests/init.pp)
```sh
../modules/apache
    |- files
        |- httpd.conf
    |- manifests
        |- init.pp
```
- Node configuration: [`/etc/puppetlabs/code/environments/production/manifests/site.pp`](./apache/site.pp)


## Variables

- Variables in Puppet are prefixed with `$`.
- Assigned with `=`.
- Must begin with a lowercase letter or underscore.
- The variable name can include alphanumeric and underscores.
- `$pkgname = 'httpd'`
- Once declared, a variable cannot be modified or re-declared. Variables are constants.
- Variables can be used for resource titles.
- variables can be used for resource attribute values.
- [variables](variables.pp)

### Variable Interpolation

- Strings in Puppet should always be quoted.
- Single quotes for static content.
- Double quotes for interpolated content.
- When interpolating a variable into a string, the variable should be in brackets.
```puppet
$prefix = 'README'
$suffix = 'txt'

$filename = "${prefix}.${suffix}"
```


### Arrays

- Array items are declared inside square brackets.
- `[ ]` Denotes an array.
- Can use an array in the resource title, this creates multiple resources.
- Some resource types take arrays for their attributes.
- [arrays.pp](arrays.pp)
- Arrays can be written directly into resource declarations.
- Resource references are no different.


### Hashes

- Hashes are declared using brackets `{ }`.
- Key values are separated by a hashrocket (`=>`).
- Values can be looked up by placing the hash key in square brackets.


### Scope of existance for Variables

- Variables exist within a scope.
- Generally it is the class that's been declared within.
- Puppet has the concept of a top scope, for any variable declared outside of any particular class.
- If a variable is not found in the current scope, the next scope is searched, which is the top scope.
- Scopes are namespaced with `::`.
    - Top_scope: `$var = 1`
    - Class_scope: `$var = 2`
- To explicitly reference the top scope var we need to explicitly fully qualify it, `::var`


### Facts Revisited

- [Facts](#facter)
- Agent facts are sent to the server and available in a *hash* called `$::facts`.
- We can use the `facter` command to view facts on the CLI.
- Facts are also top level variables, but the `$::facts` hash is recommended.


#### Trusted Facts

- Trusted facts are retrieved from the Agents SSL certificate.
- They are stored in a top level hash called `$::trusted`.


## Conditionals

### Controlling Flow

- Assignment conditionals
    - Selectors
- Flow conditionals
    - Case statements
    - If/Else
- [conditionals.pp](./conditionals.pp)

#### Selectors

- Selectors assign data based on an evaluation.
- They do not control the flow of code.


#### Case Statements

- Case statements execute a block of code depending on the evaluation.


#### Regular Expressions

- Both case statements and selectors can use regular expressions.
- A standard regex is declared between two forward slashes (`/`) with no quotes.


#### If/Else

- If / else / elsif blocks are used to control the general flow of code.
- The block is executed if the evaluation is true.
- If statements support operators to compare two values.
    - `==` equals to
    - `!=` not equal to
    - `<` less than
    - `<=` less than or equal to
    - `>` greater than
    - `>=` greater than or equal to
    - `=~` match regular expression
- An if statement can be inverted using the `unless` keyword.


> [!NOTE]
> Case statements, If/Else statements and selectors are all case insensitive.
> RedHat == redhat == REDHAT
> If it needs to be case sensitive use a regular expression.


## Data Types

- We can express data types in the Puppet DSL as a plain word starting with an uppercase letter.
- Data types offer a way to assert that variables conform to a specific type.
- Depending on the data type, we can optionally supply parameters to narrow the validation criteria.
- For example, the String data type takes parameters of minimum and maximum length.
    - `String[5]` The number of characters the string could contain
    - `String[5, 10]` The minimum and maximum characters


### Core Data Types

#### Numeric Data Types

- We can use the data types `Integer` and `Float` to represent whole integers or floating point numbers.
- The data type `Numeric` can assert either of `Float` or `Integer`
- `Float` and `Integer` support minimum and maximum parameters
- The `Numeric` type does not support any parameters.
    - `Integer[5, 10]` between 5-10
    - `Float[1.9]` float no less than 1.9


#### Array Data Type

- The `Array` type supports tree optional parameters, the content type and the minimum and maximum length of the array.
- A special argument of `Any` is accepted for the first parameter.
    - `Array[String]`
    - `Array[Any, 5]`
    - `Array[String, 5, 10]`


#### Hash Data Type

- The `Hash` type supports foru optional parameters, the content type of the keys, content type of the values and the minimum and maximum number of keys in the hash.
    - `Hash[String, Integer]`
    - `Hash[String, Integer, 5]`
    - `Hash[String, Integer, 5, 10]`


#### Regexp Data Type

- The `Regexp` type asserts that the value given is a regular expression
    - `Regexp`


#### Undef Data Type

- The `Undef` type asserts that the value given is as an undefined value, or `undef`
    - `Undef`


### Abstract Data Types

- Core data types can be wrapped into more customized abstract types.
- These enable us to do more extensive or broader validation on values.


#### Variant Data Type

- The `Variant` data type asserts that a value can be one of a mixture of other types.
- It takes a list of data type as parameters.
    - `Variant[String, Integer]`
    - `Variant[Boolean, String]`


#### Enum Data Type

- Given a list of string parameters, `Enum` can be used to assert that the value is a string and it's value matches one of the parameters.
    - `Enum['yes', 'no']`


#### Optional Data Type

- `Optional` takes a data type as a parameter and asserts that the value matches the type of the parameter, or is `undef`
- This is similar to a `Variant` data type but with the parameter and `Undef` as the second parameter.
    - `Optional[String]` == `Variant[String, Undef]`


### Validating values

- Can use the `=~` operator to validate a value against a data type.
- The outcome of the evaluation will be `true` of `false`.
    - `$hostname =~ String[4]`
    - `$port =~ Integer`
- Data types can also be used in the evaluation of case and selector statments.


## Functions

- Puppet functions are executed in Puppet server, they are executed during catalog compilation.
- They don't run on agents.


### Server side methods

- Functions can be written in Ruby or Puppet DSL.
- Functions either return data to assign to a variable or perform an action with no retun value (statement function)
- [functions.pp](./functions.pp)


### Calling Functions

- Prefixed syntax
    - `function(arg, arg)`
- Chained syntax notation: this type requires at least one argument to be present and that argument is followed by the function and if more arguments are present they will be added within brackets seperated by commas.
    - `arg.function(arg, arg)`
- The `notice` function is a function which causes to update the notice logs in the puppet server and the `notify` resource is applied when the catalog is been compiled and notified to the agent, which causes the notice log on the agent to be updated.
    - `notice("Hello World")`
    - `"Hello World".notice`
- Functions can be found at three level.
    - Global functions: they are defined at global level which is only one version or instance is available.
        - `function`
    - Environment level functions: they are isolated according to the environment and a function in one environment may not be available in another environment.
        - `environment::function`
    - Module function: we include functions in modules and we can call that faunction by referencing the module name and `::` followed by function name.
        - `modulename::function`


### Assignment Functions

- Always returns a value and we have to assign that value to something.
    - `$hash = md5('Hello World')` : takes a string and returns the `md5` hash of that string.


### Lambdas (code Blocks)

- Code blocks provide "anonymous functions"
- Usually a function will yield an object (parameter) within the code block.
- Following the function call with one or more parameters that the function yields, between pipe symbols, and then a set of curly braces that contains our code block.
- Prefixed syntax
    - `function(arg, arg) |param, param| { }`
- Chained syntax notation
    - `arg.function(arg) |param, param| { }`


### Loops & Iterators

- A common use of code blocks to iterate over hashes or arrays.
- The `each` function supports two parameters when used with a hash.
- If the `$vhosts` variable is a hash containig hostnames mapped to ports we can iterate.


### Data Validation in Code Blocks

- We can include data validation in code blocks by expressing parameters prefixed with data types.


### Writing Functions

- Puppet supports three types of functions.
    - Legacy Ruby API (will be depricated)
    - Modern Ruby API
    - Puppet DSL Functions
- The Legacy API should be avoided;
    - It will be depricated in future versions.
    - A function written in the legacy api is global to all environments.
    - They do not support the new Puppet data types.
- The modern ruby function API supports namespaced functions that don't bleed into other environments.
- Ruby functions are normally deployed from within Pupper modules.
- `<modulepath>/<modulename>/lib/puppet/functions/name.rb`


#### Writing Ruby Functions

- A simple ruby function consist of a call to `Puppet::Functions.create_function()` with a ruby method defined within the block.
- [sayhello.rb](sayhello.rb)
- The filename should be the function name.
- Data types can be validated using the dispatch method.


#### Writing Puppet Functions

- Puppet functions are written completely in the native Puppet DSL.
- Puppet functions are usually developed from the functions directory of the module root, from a filename matching our function name.
- [sayhello.pp](sayhello.pp)
- `<modulepath>/<modulename>/functions/<functionname>.pp`


## Templates

- We embed code into static content to create templates.
- Templates are normally used for serving dynamic file contents.
- Puppet supports two template formats,
    - EPP (Embedded Puppet), Native Puppet DSL templates.
    - ERB (Embedded Ruby), Legacy Ruby templates.


### Calling Puppet Templates

- EPP Templates are called using the in-built `epp` function.
- Templates are served from the `templates` folder directly under the module root.
    - `<modulepath>/<modulename>/templates/<name>.epp`
    - `<modulepath>/<modulename>/templates/<name>.erb`
- The `epp` function is used to render a template and return the content.
- The first argument is the location of the template as `<modulename>/<file>`.
- `<file>` is relative to the templates folder directly under the module root.
    - `<modulepath>/<module>/templates/<template_name>.epp`
    - `<modulename> => <modulepath>/<module>`
    - `<file> => /templates/<template_name>.epp`
- The second argument is a hash of parameters to pass to the template.
- [puppet_templates.pp](./puppet_templates.pp)


### Writing Puppet Templates

- Templates are static content with embedded dynamic tags surrounded by `<% .... %>`.
- There are thress types of tags,
    - `<% | .... | %>` Parameter tag
    - `<% .... %>` Functional tag
    - `<%= .... %>` Expression substitution tag


> [!NOTE]
> When templates are being rendered, we get nelines or additional whitespaces due to the functional code rendering in the file.
> For this we can use the *Whitespace Controlling.*
> Examples are, 
> [Templar](https://silentvoid13.github.io/Templater/commands/whitespace-control.html#:~:text=Templater's%20whitespace%20control%20utility%20allows%20you%20to,tag**%20Trims%20one%20newline%20after%20the%20command)
> [Templates](https://github.com/puppetlabs/puppet-specifications/blob/master/language/templates.md)
> [Liquid](https://shopify.github.io/liquid/basics/whitespace/)
> [Nunjucks](https://mozilla.github.io/nunjucks/templating.html#whitespace-control)
> [JinjaTags](https://www.redpill-linpro.com/techblog/2023/07/19/jinja_whitespaces.html)


### Dynamic File Content with Templates

- Can set file contents using the content attribute of the file resource type.
- [puppet_templates.pp](./puppet_templates.pp)


## Parameterized Classes

- Puppet classes should be designed to be re-usable, sharable components.
- Can use class parameters to make instantiations of a class customizable.
- To parmaeterize a class, add a section right after the class name enclosed with brackets `( ... )` and list the configurable parameters as a comma seperated list.
- Then add the class code within the curly brackets `{ ... }`.


### Declaring a class

- Can use the `include` function or class declaration syntax to declare a class.
    - `include apache`
    - `class { 'apache': }`
- For parametrized classes we have to use declaration syntaxx to declare the class.


#### Resource declaration syntax

- Using the resource declaration syntax we can pass parameters to a class the same way as resource attributes.
- Parameters are mandatory unless they have a default.
- Can use data types to validate the input into the class.
