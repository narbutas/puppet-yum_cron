# == Class: yum_cron::params
#
# The yum_cron configuration settings.
#
# === Authors
#
# Trey Dockendorf <treydock@gmail.com>
#
# === Copyright
#
# Copyright 2013 Trey Dockendorf
#
class yum_cron::params {

  case $::osfamily {
    'RedHat': {
      $package_name       = 'yum-cron'
      $service_name       = 'yum-cron'
      $service_hasstatus  = true
      $service_hasrestart = true

      case $::operatingsystemmajrelease {
        '7': {
          $config_path      = '/etc/yum/yum-cron.conf'
        }
        '6': {
          $config_path      = '/etc/sysconfig/yum-cron'
        }
        '5': {
          $config_path      = '/etc/sysconfig/yum-cron'
        }
        default: {
          fail("Unsupported operatingsystemmajrelease: ${::operatingsystemmajrelease}, module ${module_name} only support 5, 6, and 7")
        }
      }
    }

    default: {
      fail("Unsupported osfamily: ${::osfamily}, module ${module_name} only support osfamily RedHat")
    }
  }

}