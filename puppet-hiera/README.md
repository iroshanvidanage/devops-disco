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

