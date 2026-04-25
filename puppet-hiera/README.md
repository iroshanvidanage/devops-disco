# Puppet: Hiera

- Hiera: is the puppet's data lookup subsystem.
- Pronounced as `high-ruh`.
- It is all about managing the data, the parameterised values are used to complie the puppet code for different scenarios.


### Main Strengths

- Seperate data from the code.
- Provide hierarchical style lookups.
- Enables to manage complex data easily.


### Core Features

- Single source of truth for system wide configuration.
- Pluggable backends;
    - Files
    - Databases
    - HTTP API endpoints
- Secrets handling.
- Hierarchical overrides.


## Data Separation

- Complex code paths are eliminated.
- Modules can be shared and re-used by others.
- Collabaration on Puppet code across the organization.
- A thriving online community developing modules [forge.puppet.com](https://forge.puppet.com).


## Hierarchical Lookups

- Infrastructure growths adds complexity
- Configuration values are different;
    - Location
    - Environment
    - Deployment type ...etc
- Define global defaults for configuration values.
- Override based on narrowing criteria, eg:
    - Environment
    - Data center
    - Host name
- All without touching any code!
- Hierarchical lookups are suited to infrastructure.
- We often express infrastructure from most granular to most encompassing factors.
- `Hostname` => `Environment` => `Location` => `Common`
- Configuration is in `YAML` format.
- Default location for `hiera.yaml`.
    - `/etc/puppetlabs/code/environments/production/hiera.yaml`
- `hiera.yaml` defines a hierarchy of lookups.
- Each lookup may contain;
    - Backend to use (default YAML).
    - Paths to search.
    - Backend specific options.


### Configurations

#### Version

- Configuration file must declare Hiera version, the hiera that ships with Puppet 6 is now is `version 5`.
```yaml
---
version: 5
```

#### Hierarchy Key

- The second configuration stanza in this file is `hierarchy` each level of the hierarchy is an array of element which contains a hash.
- Each level will have a name to identify it, and then a series of options, including those specific to the backend.
```yaml
hierarchy:
    - name: "Global configuration"
      path: "common.yaml"
```

#### Defaults Key

- The third stanza within hiera yaml is `defaults`.
- Can apply default values to all hierarchy levels.
```yaml
defaults:
    datadir: data
    data_hash: yaml_data
```


### Options

#### Data Store Location

- The location where data is stored.
- If unqualified, ralative to location of `hiera.yaml`.
    - `datadir: data`

#### Lookup Backend

- `data_hash` or `lookup_key`, to understand which one to use we need to understand the behavior of the backend.
- The backend could interact with hiera in two ways,
    - All in one query: queried once and return a large data structure containing all of the keys and values it finds.
    - Single key per lookup: simgle key requests and then in return, single values.
- We could have only one lookup key per hierarchy level.
- `data_hash` is used when all data can be returned from single query.
- `lookup_key` is used for single key lookups.
- The most used and default backend is `yaml_data`, a backend that can return the entire data structure in one query.
    - `data_hash: yaml_data`


### YAML_DATA

#### The YAML Backend

- Built-in to Puppet core.
- Reads data from a hierarchy of YAML files.
- Returns all data in one lookup.
    - `data_hash: yaml_data`

#### Options: path

- The `path` option points to a single YAML file.
```yaml
defaults:
    datadir: data
    data_hash: yaml_data

hierarchy:
    - name: "Global configuration"
      path: "common.yaml"
```

`./data/common.yaml`

#### Options: paths

- Using `paths` we can specify multiple paths.
- They will be scanned top-to-bottom.
- Argument must be an array.
```yaml
hierarchy:
    - name: "Global configuration"
      paths: 
        - common/network.yaml
        - common/infrastructure.yaml
```

#### Options: glob

- Using `glob` we can specify wildcards paths.
```yaml
hierarchy:
    - name: "Global configuration"
      glob: "common/*"
```

- Example [hiera.yaml](./hiera.yaml) v5.


## Hiera Data

### Data Lookup Methods

- Command line with `puppet lookup`.
- Puppet `lookup` function.
- Automatic parameter lookup (data binding).

#### Keys

- Keys are namespaced to a Puppet class.
- Similar to Puppet, using a `::` delimiter.
```puppet
motd::message: Welcome to the Acme Corp network
```


### Populating Data

#### Using the command line

- Data can be queried using `puppet lookup`.
- First argument is the key to lookup.
```sh
puppet lookup motd::message
```
- Example [common.yaml](./data/common.yaml) lookup.
```sh
puppet lookup greeting

# can render as with different formats
puppet lookup greeting --render-as json

# verbose how hiera lookup for data
puppet lookup greeting --explain
```

#### Lookup function in Puppet

- Puppet has a function called `lookup`.
- Perform a Hiera lookup within code.
```puppet
lookup('motd::message', String)
```
- Example [data_lookup.pp](./data_lookup.pp)

#### Automatic Data Bindings

- Puppet automatically looks up class parameters.
```puppet
class apache (
    Integer $port = 80,
) {
    ...
}
```
- Puppet will attempt to lookup `apache::port`.
- Data bindings can be overridden by a declaration. for the first declaration therewon't be a lookup.
- For the second and third declarations there'll be data lookups.
```puppet
class { 'apache':
    port => 8080,
}

class { 'apache': }

include apache
```

#### Order of Precedence

- Parameter specified in class declaration.
- Automatic Hiera lookup.
- Default specified within class.

#### Automatic Data Binding with public classes

- [data_lookup.pp](./data_lookup.pp)


## Dynamic Hierarchies

### Using Facts

- Hiera's configuration file can interpolate facts.
- Facts are used to determine the hierarchy.
- Interpolation syntax is `%{ var }`.
- Several top scope variables can be accessed.
- Agent facts are available as facts.
- Facts can be used to define hierarchy paths.
- Hash sub-keys are referenced using a dot notation.
    - `%{facts.os.name}`
- By using facts we can make hierarchy paths dynamic.
- Examples: [hiera.yaml](hiera.yaml): [RedHat.yaml](./data/os/RedHat.yaml), [CentOS.yaml](./data/os/CentOS.yaml)
- The values are overridden depending on the hierarchy in the hiera.yaml.
- The priority is given to the top most configuration in the hierarchy.


## Dynamic Data 

### Variable Interpolation

- Variables can be used in Hiera data too.
- Hiera can interpolate various variables.
    - Facts
    - Trusted facts
    - Server facts
    - Top level variables
- The `%{  }` syntax can be used within data.
- Example [common.yaml](./data/common.yaml)

### Function Interpolation

- Hiera functions can perform further tasks on lookups.
- Functions are only used in data.
- Current supported functions include;
    - `alias`
    - `lookup`
    - `literal`
- To call a function a synctax similar to variables is used.
- Arguments placed in parenthesis.

#### `alias` function

- Re-use an existing hash, array or boolean.
- Example [common.yaml](./data/common.yaml)
- Cannot interpolate with strings just only the entier key can be used.

>[!NOTE]
> This creates a map with a key named example.com and no value, which is very different from just substituting the string.
> Key Difference
> - alias(%{'domain'}) → substitutes the scalar value directly.
> - %{ alias('domain') } → treats the scalar as a map key, which can lead to unexpected or invalid structures if you intended a simple value.
> 
> ✅ So:
> - Use alias(%{'... ‘}) when the alias points to a scalar or list you want directly substituted.
> - Use %{ alias('...') } when you want to interpolate into a map structure (usually with lists, not scalars).


#### `lookup` function

- Hiera equivilent of a sub-query.
- perform a Hiera llookup and return the result
```yaml
monitoring::http_port: "%{ lookup('apache::port') }"
```
- Referenced data can be anywhere in the hierarchy, doing a full hiera lookup.
- Lookups can be used in interpolation, and can build different data sets.
- Has a synonym `hiera`, this is built for lecagcy compatibility.
```yaml
monitoring::http_port: "%{ hiera('apache::port') }"
```

#### `literal` function

- A simple function to escape the `%` character.
- Hiera will try and interpolate strings with `%`.
- As an example if we do the apache configurations, 
```yaml
web::rewrites:
    - "%{SERVER_PORT} '!^80$'"

- " '!^80$'"
```
- This is going to give a warning.
```bash
Warning: Undefined variable 'SERVER_PORT';
```
- To escape this can use `literal` function.
```yaml
web::rewrites:
    - "%{ literal('%') }{SERVER_PORT} '!^80$'"

- "%{SERVER_PORT} '!^80$'"
```

> [!CAUTION]
> - Overusing functions leads to complicated data paths.
> - Evaluate when the logic would be better in code or better in hiera data.
> - Nested lookups are possible but unwise.
> - Useful for edge case scenarios.


## Data Lookup Behaviour

### Merging and Cascading

- By default, Hiera returns the first result.
- The remaining hierarchy is skipped.
- Sometimes we do not want just the first result.
- A lookup can cascade through all levels of the hierarchy.
- All results are returned as an array or hash.
```yaml
# config file 1
system::packages: ['php5', 'apache', 'java']

# config file 2
system::packages: ['libgcc++', 'autoconf']

# needs to return all -- merge unique
['php5', 'apache' , 'java', 'libgcc++', 'autoconf']
```

### Merge Types

- Hiera supports several lookup behaviours.
- The default is `first`: Return the first found result and skip.
- Other merge behaviours are;
    - `unique`
    - `hash`
    - `deep`
- Using the cli: `puppet lookup system::packages --merge unique`
- Using lookup function in Puppet: `$packages = lookup('system::packages', Array, 'unique')`

#### `unique`

- Walks through each hierarchy level and collects all instances of the key, then retruns an array of all results.
- Each element is unique, if we have two of the same element only one is returned.
- Can use for strings and arrays, but cannot use them for hashes.

#### `hash`

- Walks through each hierarchy level, expects all matching values to be hashes, merges all answers into one hash.
- Two data sets with same variable name in two places in hierarchy, merges into one hash.
- Here the top level keys needs to be unique through the hierarchy.
- Examples [app_repo.yaml](./data/app_repo.yaml), [dba_repo.yaml](./data/dba_repo.yaml)
```yaml
{
    "application" => {
        "baseurl" => "http://yum.example.com/application",
        "gpgkey" => "http://yum.example.com/RPM-GPG-KEY-application"
        },
    "dba" => {
        "baseurl" => "http://yum.example.com/dba",
        "gpgkey" => "http://yum.example.com/RPM-GPG-KEY-dba"
        }
}
```

#### `deep`

- Aka `deep hash`, best used for overriding certain values from hashes.
- The port for intra in [common.yaml](./data/common.yaml) has been overridden in [sites.yaml](./data/sites.yaml)
- But `hash` merging only keeps the port value, here we need to keep the rest of the hash values intact otherthan for the port.
- For this we can use `deep`.
- `puppet lookup apache::sites --merge hash`

#### Lookup Options

- We can change the lookup behaviour of a key without altering any code; by using `lookup_options` in the hierarchy.
- When hiera does lookup it first lookup for `lookup_options` in the background.
- We can specify `loopup_options` in the [common.yaml](./data/common.yaml) and execute following;
    - `puppet lookup apache::sites`

> [!NOTE]
> `puppet lookup apache::sites --explain` allows you to see how the lookup is working how puppet is traversing through all hiera.


## Data in Modules

### Replacing parameter patterns

- A popular pattern for defining default values; specially when defaults need to be dynamic.
- [params_pattern.pp](./params_pattern.pp)


### Configuration Levels

- A Hiera configuration is searched for on 3 levels.
    - Global level
    - Environment level
    - Module level
- Merge lookups doesn't transcend configuration levels, it transcend the heirarchy within a configuration level.
- **Global**:-
    - First to be searched.
    - Used to globally override values.
    - `/etc/puppetlabs/puppet/hiera.yaml` - this is the lookup location.
- **Environment**:-
    - The standard place to configure Hiera.
    - Each env can implement it's own config.
    - Allows for changes to be tested and release managed.
    - `/etc/puppetlabs/code/environments/production/hiera.yaml` - this is the lookup location.
- **Module**:-
    - Tha last location to be searched.
    - Only used for keys matching it's own namespace.
    - Used to specify module default values.
    - Can contain `lookup_options` for local keys.
    - `<module path>/apache/hiera.yaml` - this is the lookup location.



## Sensitive Data - Handling Secrets in Hiera

- Hiera data is usually stored in VCS repos (Git).
- Any person who has access to the puppet code needs access to Hiera data as well.
- Some data shouldn't be visible or accessible for every one who has access to the data.
    - Passwords
    - Credentials
    - Access tokens
    - Certificates
- **EYAML** a plugin bundled with puppet 6 and above to encrypt values in hiera.
- EYAML is a community driven project not supported officially.
- Allows in-line encryption of sensitive values.
    - `mysql::password: supers3crEt` - plain text version.
    - `mysql::password: ENC[PKCS7,MIIBeQYJKoZIhvcNFg3jAmdlCLbQ]` - encrypted inline.


### EYAML

- Can encrypt plain text strings and entire files.
- By default it uses *PKCS7* encryption.
- Supports pluggable encryptors:
    - GPG
    - KMS (AWS)
    - GKMS (Google Cloud)
    - Vault secret engine - use the vault to store the secret and as a service it retrieves the secret at deployment.
- Only the person with the key can decrypt the encrypted Hiera data.

### EYAML Installation

- Ruby is used by puppet for plugins, which is the bundles ruby gem for plugins.
- Puppet CLI and Puppet Server which is running jRuby.
- `/opt/puppetlabs/puppet/bin/gem list hiera-eyaml`
- `puppetserver gem list hiera-eyaml`
- For older versions of Puppet
```bash
/opt/puppetlabs/puppet/bin/gem install hiera-eyaml
puppetserver gem install hiera-eyaml
systemctl restart puppetserver
```
- To update hiera-eyaml to the latest version
```bash
/opt/puppetlabs/puppet/bin/gem update hiera-eyaml
puppetserver gem update hiera-eyaml
systemctl restart puppetserver
```
- Once installed `eyaml` commands will be available.
    - `eyaml version`
- Puppet Ruby commands are in `/opt/puppetlabs`
    - `export PATH=$PATH:/opt/puppetlabs/puppet/bin`
- Eyaml subcommands:
    - createkeys
    - encrypt
    - recrypt
    - decrypt
    - edit

### Creating Keys

- EYAML needs a set of keys to encrypt and decrypt, private & public keys.
- Stored in a location readable by puppet; `/etc/puppetlabs/puppet/eyaml/`
- `eyaml createkeys`; default location in current directory `./keys/`
- Make sure the ownership is puppet.

### Configuration

- EYAML config file locations:
    - `~/.eyaml/config.yaml`
    - `/etc/eyaml/config.yaml`
    - If not custom location can be provided by `EYAML_VAULT` env variable.
- If using `pkcs7` keys need to specify the location in config file.
```yaml
pkcs7_public_key: /etc/puppetlabs/puppet/eyaml/public_key.pkcs7.pem
pkcs7_private_key: /etc/puppetlabs/puppet/eyaml/private_key.pkcs7.pem
```
- If we are using a 3rd party encryption plugin,
    - Need to override the default from `encrypt_method`
    - Each encryption plugin may take it's own options.
    - `encrypt_method: 'gpg'`

### Encrypting Data

- `eyaml encrypt` command is used to encrypt;
    - Plain strings (`-s`)
    - Entire files (`-f`)
```bash
eyaml encrypt -s secretPassword

echo secretSauce > secret.txt
eyaml encrypt -f secret.txt
```

- Returns two output formats, `--output [ string | block ]`
- Single line; `string: ENC[PKCS7,Nhofhdoahsii...]`
- Multi-line (YAML encoded)
```yaml
block: >
    ENC[PKCS7,Nhofhdoahsiihaduwhihfaijpeu9qh740r3ytr9yn238cr7u23496rc946c569696596c062569g2cn5f12707nx03n40c7tyroaigfoto640vuijmu-xjmpmSWUYFIFOU^R*%()Y)Tdew6kijfkljfede6LordkdKHDKY]
```
- Encrypted strings are in Base64 for handling as plain text. `ENC[<ENCRYPTION_PROVIDER>,<BASE_64_ENCODED_STRING>]`
- Default is `PKCS7` if no provider is given.
- `eyaml encrypt -f test.plaintext --output string > text.encrypted`

### Decrypting Data

- `eyaml decrypt` command is used to decrypt;
    - A strings (`-s`)
    - A files (`-f`)
```bash
eyaml decrypt -s "ENC[PKCS7,Nhofhdoahsii...]"

eyaml decrypt -f test.encrypted
```

### Editing Files to Add Data to Hiera

- `eyaml edit` used to edit files in-line.
- Editor can be defined in `$EDITOR` var.
- Encrypted strings will be presented in plain text.
- `DEC(1)::PKCS7[secret]!`
- When adding new block donot add a number.
- `mysql::password: DEC::PKCS7[token_for_data]!`

### Configure Hiera to use Eyaml

- `eyaml_lookup_key` is used to lookup encrypted eyaml values.
- It's a single key lookup function.
- Can be used at any level of the hierarchy.
- [eyaml_hiera.yaml](./eyaml_hiera.yaml)
- [eyaml_defaults_hiera.yaml](./eyaml_defaults_hiera.yaml)
