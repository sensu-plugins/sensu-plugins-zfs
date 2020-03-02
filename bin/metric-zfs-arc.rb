#!/usr/bin/env ruby
# frozen_string_literal: true

#
#   ZFS ARC metrics
#
# DESCRIPTION:
#   This collects ZFS ARC (Adaptive Replacement Cache) metrics
#   metric-zfs-arc.rb looks at /proc/spl/kstat/zfs/arcstats
#
# OUTPUT:
#  metric data
#
# PLATFORMS:
#   Linux
#
# DEPENDENCIES:
#   gem: sensu-plugin
#   gem: socket
#
# USAGE:
#  ./metric-zfs-arc.rb
#
# NOTES:
#
# LICENSE:
#   Copyright 2019 Airbrake Technologies, Inc <support@airbrake.io>
#   Released under the same terms as the Sensu (the MIT license); see LICENSE
#   for details.

require 'sensu-plugin/metric/cli'
require 'socket'

#
# ZFS Arc Metrics
##
class ZfsArcMetrics < Sensu::Plugin::Metric::CLI::Graphite
  option :scheme,
         description: 'Metric naming scheme, text to prepend to .$parent.#child',
         short: '-s SCHEME',
         long: '--scheme SCHEME',
         default: "#{Socket.gethostname}.zfs"

  def run
    # ZFS ARC statistics
    #
    # Here is sample output on a test system from the first 5 lines
    #
    #  /proc/spl/kstat/zfs/arcstats
    #
    # 13 1 0x01 96 26112 830229407922 1845600063633972
    # name                            type data
    # hits                            4    3013872557
    # misses                          4    46742397
    # demand_data_hits                4    2128530805

    if File.exist?('/proc/spl/kstat/zfs/arcstats')
      File.read('/proc/spl/kstat/zfs/arcstats').split("\n").drop(2).each do |row|
        unless row.nil?
          name, _type, data = row.split
          output "#{config[:scheme]}.#{name}", data
        end
      end
      ok
    else
      critical "File: '/proc/spl/kstat/zfs/arcstats' does not exist "
    end
  end
end
