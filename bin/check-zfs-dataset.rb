#!/usr/bin/env ruby

require 'sensu-plugin/check/cli'
require 'sensu-plugins-zfs'

class CheckZFS < Sensu::Plugin::Check::CLI
  option :dataset,
         short: '-d DATASET',
         long: '--dataset DATASET',
         description: 'Name of dataset to check. If omitted, we check all datasets'

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

  def run
    @warnings = []
    @criticals = []
    zfslist = []
    if config[:dataset]
      zfslist << SensuPluginsZFS::ZfsList.new(config[:dataset])
    else
      zfslist = SensuPluginsZFS::ZFS.zfslist
    end
    zfslist.each do |ds|
      check_percentage ds
    end
    puts @criticals
    puts @warnings
    critical @criticals.join(', ') unless @criticals.empty?
    warning @warnings.join(', ') unless @warnings.empty?
    if config[:dataset]
      ok "dataset #{config[:dataset]} is ok"
    end
    ok 'all datasets are ok'
  end

  private

  def check_percentage(ds)
    if ds.check_percentage_quota > config[:cap_crit].to_i
      @criticals << "dataset #{ds.name} is above #{config[:cap_crit]}% (currently #{ds.available} left, quota: #{ds.quota})"
    elsif ds.check_percentage_quota > config[:cap_warn].to_i
      @warnings << "dataset #{ds.name} is above #{config[:cap_warn]}% (currently #{ds.available} left, quota: #{ds.quota})"
    end
  end

end
