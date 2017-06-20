# Class: puppet_agent_cleanser
# ============================
#
# Installs mgo agent and application for cleansing puppet agent run states
#
# Parameters
# ----------
#
# * `include_app`
# Whether to install the mco app. Default: true

# * `include_agent`
# Whether to install the mco agent. Default: true
#
# Examples
# --------
#
# @example
#    class { 'puppet_agent_cleanser':
#      include_app => true,
#    }
#
# Authors
# -------
#
# Jesse Reynolds <jesse.reynolds@puppet.com>
#
# Copyright
# ---------
#
# Copyright 2017 Jesse Reynolds
#
class puppet_agent_cleanser (
  Boolean $include_app   = true,
  Boolean $include_agent = true,
) {

  if versioncmp($::puppetversion, '4.0.0') < 0 {
    fail("This module is targeted at Puppet 4 and above, not Puppet ${::puppetversion}")
  }

  $mco_svc = 'mcollective'
  $ensure_agent = $include_agent ? {
    true    => 'file',
    default => 'absent',
  }

  $ensure_app = $include_app ? {
    true    => 'file',
    default => 'absent',
  }

  $ensure_ddl = ($include_app or $include_agent) ? {
    true    => 'file',
    default => 'absent',
  }

  case $facts['kernel'] {
    'Windows': {
      $mco_dir = 'C:/ProgramData/puppetlabs/mcollective/plugins/mcollective'
      File {
        owner  => 'S-1-5-32-544', # Adminstrator
        group  => 'S-1-5-32-544', # Adminstrators
        mode   => '0664',         # Both user and group need write permission
      }
    }
    'Linux', 'SunOS': {
      $mco_dir = '/opt/puppetlabs/mcollective/plugins/mcollective'
      File {
        owner  => 'root',
        group  => 'root',
        mode   => '0644',
      }
    }
    default: {
      fail("Unsupported OS: ${facts['kernel']}")
    }
  }

  file {'puppet_agent_cleanser_agent_ddl':
    ensure => $ensure_ddl,
    path   => "${mco_dir}/agent/puppet_agent_cleanser.ddl",
    source => 'puppet:///modules/puppet_agent_cleanser/mco_agent/puppet_agent_cleanser.ddl',
    notify => Service[$mco_svc],
  }

  file {'puppet_agent_cleanser_agent':
    ensure => $ensure_agent,
    path   => "${mco_dir}/agent/puppet_agent_cleanser.rb",
    source => 'puppet:///modules/puppet_agent_cleanser/mco_agent/puppet_agent_cleanser.rb',
    notify => Service[$mco_svc],
  }

  file {'puppet_agent_cleanser_application':
    ensure => $ensure_app,
    path   => "${mco_dir}/application/puppet_agent_cleanser.rb",
    source => 'puppet:///modules/puppet_agent_cleanser/mco_application/puppet_agent_cleanser.rb',
  }
}
