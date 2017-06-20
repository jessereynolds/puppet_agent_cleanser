# puppet_agent_cleanser

#### Table of Contents

1. [Description](#description)
1. [Usage](#usage)
1. [Limitations](#limitations)
1. [Development](#development)

## Description

This Puppet module installs an [MCollective](https://docs.puppet.com/mcollective/) application and agent for cleaning up the state of your running Puppet agents should they become stuck for whatever reason (eg a rogue firewall stole your TCP state and left your Puppet agents with half-open connections to the master.)

## Usage

By default, including the `puppet_agent_cleanser` class will install both the MCollective Agent and Application. If you want to be more selective you can disable one or other, eg:

```puppet
class { 'puppet_agent_cleanser':
  include_app   => false,
  include_agent => true,
}
```

## Limitations

This has been developed with Linux agents in mind. It should work on any UNIX type OS but has only been tested on RHEL 6 to date. It will need a bit of work to get working on Windows due to pathing assumptions.

## Development

Pull requests welcome! Raise an issue if you want to discuss a possible feature addition, report a bug, etc.

