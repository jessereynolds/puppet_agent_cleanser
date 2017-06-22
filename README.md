# puppet_agent_cleanser

#### Table of Contents

1. [Description](#description)
1. [Usage](#usage)
1. [Limitations](#limitations)
1. [Development](#development)

## Description

This Puppet module installs an [MCollective](https://docs.puppet.com/mcollective/) application and agent for cleaning up the state of your running Puppet agents should they become stuck for whatever reason (eg a rogue firewall stole your TCP state and left your Puppet agents with half-open connections to the master.)

## Setup

By default, including the `puppet_agent_cleanser` class will install both the MCollective Agent and Application. If you want to be more selective you can disable one or other, eg:

```puppet
class { 'puppet_agent_cleanser':
  include_app   => false,
  include_agent => true,
}
```

## Usage

Obtaining status of one (or more) machines: `mco puppet_agent_cleanser status`

If number of agent processes is more than 1 for an extended period then it's likely the forked child process of the agent has hung, as seen below.

Eg:

```
$ mco puppet_agent_cleanser status -I foo.example

 * [ ============================================================> ] 1 / 1


foo.example
   Puppet Agent Status: 2 process.



Finished processing 1 / 1 hosts in 1087.47 ms
```

We can now target this machine to have its Puppet agent cleanly restarted (including killing of any stuck child processes and deletion of the agent catalog run lockfile) by running `mco puppet_agent_cleanser cleanse`

Eg:

```
$ mco puppet_agent_cleanser cleanse -I foo.example

 * [ ============================================================> ] 1 / 1


foo.example
   Cleanse result: success



Finished processing 1 / 1 hosts in 19230.85 ms
```

## Limitations

This has been developed with Linux agents in mind. It should work on any UNIX type OS but has only been tested on RHEL 6 to date. It will need a bit of work to get working on Windows due to pathing assumptions.

## Development

Pull requests welcome! Raise an issue if you want to discuss a possible feature addition, report a bug, etc.

