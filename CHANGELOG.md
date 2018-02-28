# Change Log
This project adheres to [Semantic Versioning](http://semver.org/).

This CHANGELOG follows the format located [here](https://github.com/sensu-plugins/community/blob/master/HOW_WE_CHANGELOG.md)

## [Unreleased]

## [2.0.1] - 2018-02-27
### Changed
- this is a no-op release to test the CI pipeline's ability to publish gems

## [2.0.0] - 2018-02-27
### Security
- updated rubocop dependency to `~> 0.51.0` per: https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-8418 (@majormoses)

### Breaking Changes
- in order to bring in the newer rubocop we had to drop ruby `< 2.1` support (@majormoses)

### Changed
- accepted into community, a bunch of initial house keeping (@majormoses)

### Fixed
- fix scrub-in-progress command
- properly parse the list of vdevs
- fix checking all zpools (#2)

[Unreleased]: https://github.com/sensu-plugins/sensu-plugins-zfs/compare/2.0.1...HEAD
[2.0.0]: https://github.com/sensu-plugins/sensu-plugins-zfs/compare/2.0.0...2.0.1
[2.0.0]: https://github.com/sensu-plugins/sensu-plugins-zfs/compare/bf20f6b2538849a9263dbaa8771d649b7173d8b1...2.0.0
