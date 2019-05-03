#!/usr/bin/env ruby
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
    if File.exist?('/proc/spl/kstat/zfs/arcstats')
      command = 'cat /proc/spl/kstat/zfs/arcstats'

      `#{command}`.split("\n").drop(2).each do |row|
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
