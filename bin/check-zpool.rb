#!/usr/bin/env ruby

require 'sensu-plugin/check/cli'
require 'sensu-plugins-zfs'

class CheckZPool < Sensu::Plugin::Check::CLI
  option :zpool,
         short: "-z ZPOOL",
         long: "--zpool ZPOOL",
         description: "Name of zpool to check. If omitted, we check all zpools"

  option :cap_warn,
         short: "-c PERCENTAGE",
         long: "--capacity-warn PERCENTAGE",
         description: "Warn if capacity is above this threshold",
         default: 80

  option :cap_crit,
         short: "-C PERCENTAGE",
         long: "--capacity-crit PERCENTAGE",
         description: "Crit if capacity is above this threshold",
         default: 90

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
      check_capacity zp
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

  def check_capacity(zp)
    if zp.capacity > config[:cap_crit].to_i
      critical "capacity for zpool #{zp.name} is above #{config[:cap_crit]}% (currently #{zp.capacity}%)"
    elsif zp.capacity > config[:cap_warn].to_i
      warning "capacity for zpool #{zp.name} is above #{config[:cap_warn]}% (currently #{zp.capacity}%)"
    end
  end
end
