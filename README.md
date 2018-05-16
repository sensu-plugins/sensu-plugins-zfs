# SensuPluginsZFS

Sensu plugin for zfs health checks.

[![Build Status](https://travis-ci.org/sensu-plugins/sensu-plugins-zfs.svg?branch=master)](https://travis-ci.org/sensu-plugins/sensu-plugins-zfs)
[![Gem Version](https://badge.fury.io/rb/sensu-plugins-zfs.svg)](http://badge.fury.io/rb/sensu-plugins-zfs)
[![Dependency Status](https://gemnasium.com/sensu-plugins/sensu-plugins-zfs.svg)](https://gemnasium.com/sensu-plugins/sensu-plugins-zfs)
[![Community Slack](https://slack.sensu.io/badge.svg)](https://slack.sensu.io/badge)

## Checks

### check-zfs-zpool.rb

This checks does the following checks against one or more zpools.

- Check state
- Check vdev errors
- Check capacity
- Check that a scrub has been run recently

The following flags can be used to configure the checks.

- `-z, --zpool` What zpool to check. If omitted, we check all zpools.
- `-c, --capacity-warn` Capacity threshold for when to warn. (default 80)
- `-C, --capacity-crit` Capacity threshold for when to crit. (default 90)
- `-s, --scrubbing-interval` Warn when it is more than this number of days since last scrub. (default 7)

### check-zfs-dataset.rb

This checks looks for used space quota capacity

- Check quota used percentage

The following flags can be used to configure the checks.

- `-d, --dataset` What dataset to check. If omitted, we check all datasets.
- `-c, --capacity-warn` Capacity threshold for when to warn. (default 80)
- `-C, --capacity-crit` Capacity threshold for when to crit. (default 90)

## Installation
[Installation and setup](http://sensu-plugins.io/docs/installation_instructions.html)

## Contributing

At this time ideas for additional checks/metrics would be very much appreciated.

I have a few ideas that would be nice:

- [x] Check for zpool state
- [x] Check for vdev errors
- [x] Check for pool capacity
- [x] Check that disks have been scrubbed recently
- [ ] Metric for disk utilization

Bug reports and pull requests are welcome on GitHub at https://github.com/sensu-plugins/sensu-plugins-zfs.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
