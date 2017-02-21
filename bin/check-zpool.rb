#!/usr/bin/env ruby

require 'sensu-plugin/check/cli'
require 'sensu-plugins-zfs'

class CheckZPool < Sensu::Plugin::Check::CLI
  option :zpool,
         short: "-z ZPOOL",
         long: "--zpool ZPOOL",
         description: "Name of zpool to check. If omitted, we check all zpools"

  def run
    zpools = []
    if config[:zpool]
      zpools << SensuPluginsZFS::ZPool.new(config[:zpool])
    else
      zpools = SensuPluginsZFS::ZFS.zpools
    end
    zpools.each do |zp|
      check_state zp
      check_vdevs zp
    end
    if config[:zpool]
      ok "zpool #{config[:zpool]} is ok"
    end
    ok "all zpools are ok"
  end

  private

  def check_state(zp)
    unless zp.ok?
      critical "zpool #{zp.name} has state #{zp.state}"
    end
  end

  def check_vdevs(zp)
    zp.vdevs.each do |vd|
      unless vd.ok?
        warning "vdev #{vd.name} of zpool #{vd.zpool.name} has errors"
      end
    end
  end
end
