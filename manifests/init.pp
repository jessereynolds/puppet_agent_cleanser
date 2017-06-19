# Class: puppet_agent_cleanser
# ===========================
#
# Full description of class puppet_agent_cleanser here.
#
# Parameters
# ----------
#
# Document parameters here.
#
# * `sample parameter`
# Explanation of what this parameter affects and what it defaults to.
# e.g. "Specify one or more upstream ntp servers as an array."
#
# Variables
# ----------
#
# Here you should define a list of variables that this module would require.
#
# * `sample variable`
#  Explanation of how this variable affects the function of this class and if
#  it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#  External Node Classifier as a comma separated list of hostnames." (Note,
#  global variables should be avoided in favor of class parameters as
#  of Puppet 2.6.)
#
# Examples
# --------
#
# @example
#    class { 'puppet_agent_cleanser':
#      servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#    }
#
# Authors
# -------
#
# Author Name <author@domain.com>
#
# Copyright
# ---------
#
# Copyright 2017 Your name here, unless otherwise noted.
#
class puppet_agent_cleanser {

  file {'puppet_agent_cleanser_agent_dll':
    ensure => file,
    path   => '',
    source => 'puppet:///modules/puppet_agent_cleanser/mco_agent/puppet_agent_cleanser.dll',
  }

  file {'puppet_agent_cleanser_agent':
    ensure => file,
    path   => '',
    source => 'puppet:///modules/puppet_agent_cleanser/mco_agent/puppet_agent_cleanser.rb',
  }

  file {'puppet_agent_cleanser_application':
    ensure => file,
    path   => '',
    source => 'puppet:///modules/puppet_agent_cleanser/mco_application/puppet_agent_cleanser.rb',
  }
}
