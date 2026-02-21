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
