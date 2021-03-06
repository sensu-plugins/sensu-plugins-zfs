#!/usr/bin/env ruby
# frozen_string_literal: true

require 'sensu-plugin/check/cli'
require 'sensu-plugins-zfs'

class CheckZPool < Sensu::Plugin::Check::CLI
  option :zpool,
         short: '-z ZPOOL',
         long: '--zpool ZPOOL',
         description: 'Name of zpool to check. If omitted, we check all zpools'

  option :cap_warn,
         short: '-c PERCENTAGE',
         long: '--capacity-warn PERCENTAGE',
         description: 'Warn if capacity in percent is above this threshold',
         default: 80

  option :cap_crit,
         short: '-C PERCENTAGE',
         long: '--capacity-crit PERCENTAGE',
         description: 'Crit if capacity in percent is above this threshold',
         default: 90

  option :scrubbing_interval,
         short: '-s DAYS',
         long: '--scrubbing-interval DAYS',
         description: 'Warn it is more than this number of days since last scrub',
         default: 7

  def run
    @warnings = []
    @criticals = []
    zpools = []
    if config[:zpool]
      zpools << SensuPluginsZFS::ZPool.new(config[:zpool])
    else
      zpools = SensuPluginsZFS::ZFS.zpools
    end
    zpools.each do |zp|
      check_state zp
      check_capacity zp
      check_vdevs zp
      check_recently_scrubbed zp
    end
    puts @criticals
    puts @warnings
    critical @criticals.join(', ') unless @criticals.empty?
    warning @warnings.join(', ') unless @warnings.empty?
    if config[:zpool]
      ok "zpool #{config[:zpool]} is ok"
    end
    ok 'all zpools are ok'
  end

  private

  def check_state(zpool)
    @criticals << "zpool #{zpool.name} has state #{zpool.state}" unless zpool.ok?
  end

  def check_vdevs(zpool)
    zpool.vdevs.each do |vd|
      unless vd.ok?
        @warnings << "vdev #{vd.name} of zpool #{vd.zpool.name} has errors"
      end
    end
  end

  def check_capacity(zpool)
    if zpool.capacity > config[:cap_crit].to_i
      @criticals << "capacity for zpool #{zpool.name} is above #{config[:cap_crit]}% (currently #{zpool.capacity}%)"
    elsif zpool.capacity > config[:cap_warn].to_i
      @warnings << "capacity for zpool #{zpool.name} is above #{config[:cap_warn]}% (currently #{zpool.capacity}%)"
    end
  end

  def check_recently_scrubbed(zpool)
    last_scrub = zpool.scrubbed_at
    if last_scrub < Time.now - 60 * 60 * 24 * config[:scrubbing_interval].to_i # rubocop:disable Style/GuardClause
      @warnings << "It is more than #{config[:scrubbing_interval]} days since zpool #{zpool.name} was scrubbed. Last scrubbed #{last_scrub}"
    end
  end
end
