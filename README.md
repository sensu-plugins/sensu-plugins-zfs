# SensuPluginsZFS

Sensu plugin for zfs health checks.

## Checks

### check-zpool.rb

Checks if the zpool state is ONLINE and wether there has been any errors on
vdevs.

- `-z, --zpool` What zpool to check. If omitted, we check all zpools.

## Installation
[Installation and setup](http://sensu-plugins.io/docs/installation_instructions.html)

## Contributing

At this time ideas for additional checks/metrics would be very much appreciated.

I have a few ideas that would be nice:

- [ ] Check that disks have been scrubbed recently
- [ ] Check/metric for pool capacity

Bug reports and pull requests are welcome on GitHub at https://github.com/blacksails/sensu-plugins-zfs.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

