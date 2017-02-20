#! /usr/bin/env ruby

require 'sensu-plugin/check/cli'
require 'sensu-plugins-zfs'

class CheckZPool < Sensu::Plugin::Check::CLI
  def run
    zpool = SensuPluginsZFS::ZPool.new
    state = zpool.state
    message = "zpool state is #{state}"
    if state == "ONLINE"
      ok
    else
      critical
    end
  end
end
