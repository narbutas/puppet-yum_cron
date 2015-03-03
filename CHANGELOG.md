## treydock-yum_cron changelog

Release notes for the treydock-yum_cron module.

------------------------------------------

#### 2.0.0 - TBD

This release introduces many backwards incompatible changes.  The goal of this release is to make the module's behavior consistent across EL5, EL6 and EL7 despite yum-cron being drastically different across those platforms.

##### Backwards incompatible changes

* Rename `mailto` parameter to `mail_to`
* Rename `systemname` parameter to `system_name`
* Remove the following parameters
    * `yum_parameter`
    * `check_only`
    * `check_first`
    * `download_only`
    * `error_level`
    * `debug_level`
    * `randomwait`
    * `cleanday`
    * `service_waits`
    * `service_wait_time`
    * `service_autorestart`
    * `config_template`
* Change default value for `service_ensure` and `service_enable` to `undef`.  The default behavior remains the same if `enable` is `true` and `ensure` is `present`
* 

##### Features

* Add parameter `ensure` that manages the presence of yum-cron
* Add parameter `enable` that manages the state of yum-cron
* Add parameter `download_updates` that determines if updates should be downloaded
* Add parameter `apply_updates` that determines if updates should be applied
* Add parameter `package_ensure`
* Add custom type/provider to manage config values on EL7 systems
* Use shellvar type to manage config values on EL6 and EL5

------------------------------------------

#### 1.2.0 - 2015-03-02

Changes:

* Add parameter `config_template` that defines which template to use for configuring yum-cron
* Add basic EL7 support
* Move system test gem dependencies to a separate group excluded during travis-ci tests

------------------------------------------

#### 1.1.1 - 2014-11-07

Changes:

* Update beaker tests to not depend on augeasproviders

------------------------------------------

#### 1.1.0 - 2014-11-03

Features:

* Remove dependency on augeasproviders and use file_line to disable yum-autoupdates
* Add support for EL5
* Replace rspec-system tests with beaker acceptance tests
* Update unit testing dependencies

------------------------------------------

#### 1.0.0 - 2013-12-12

Backwards incompatible changes:

* Replace disable\_yum\_autoupdate and remove\_yum\_autoupdate parameters with yum\_autoupdate\_ensure

Minor changes:

* Bring regression testing up-to-date
* Remove Puppet-2.6 from travis-ci tests

------------------------------------------

#### 0.1.0 - 2013-09-18

* Replace augeas with shellvar provider for disabling yum-autoupdate 
* Add remove\_yum\_autoupdate parameter to uninstall yum-autoupdate

------------------------------------------

#### 0.0.1 - 2013-09-04

* Initial release
