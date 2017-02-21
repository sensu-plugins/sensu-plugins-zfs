# SensuPluginsZFS

Sensu plugin for zfs health checks.

## Checks

### check-zpool.rb

Checks if the zpool state is ONLINE and wether there has been any errors on
vdevs.

- `-z, --zpool` What zpool to check. If omitted, we check all zpools.
- `-c, --capacity-warn` Capacity threshold for when to warn. (default 80)
- `-C, --capacity-crit' Capacity threshold for when to crit. (default 90)

## Installation
[Installation and setup](http://sensu-plugins.io/docs/installation_instructions.html)

## Contributing

At this time ideas for additional checks/metrics would be very much appreciated.

I have a few ideas that would be nice:

- [x] Check for zpool state
- [x] Check for vdev errors
- [x] Check for pool capacity
- [ ] Check that disks have been scrubbed recently
- [ ] Metric for disk utilization

Bug reports and pull requests are welcome on GitHub at https://github.com/blacksails/sensu-plugins-zfs.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

