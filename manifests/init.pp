# == Class: yum_cron
#
# Manage yum-cron.
#
# === Parameters
#
# [*yum_parameter*]
#   String. Additional yum arguments.
#   Default: ''
#
# [*check_only*]
#   String. Sets yum-cron to only check for updates.
#   Valid values are 'yes' and 'no'.
#   Default: 'yes'
#
# [*check_first*]
#   String.  Valid values are 'yes' and 'no'.
#   Default: 'no'
#
# [*download_only*]
#   String.  Valid values are 'yes' and 'no'.
#   Default: 'no'
#
# [*error_level*]
#   String or Integer.
#   Default: 0
#
# [*debug_level*]
#   String or Integer.
#   Default: 0
#
# [*randomwait*]
#   String or Integer.
#   Default: '60'
#
# [*mailto*]
#   String. Address to send yum-cron update notifications.
#   Default: 'root'
#
# [*systemname*]
#   String.  Defaults to fqdn fact.
#
# [*days_of_week*]
#   String.  Days of the week to perform yum update checks.
#   Default: '0123456'
#
# [*cleanday*]
#   String.
#   Default: '0'
#
# [*service_waits*]
#   String.
#   Default: 'yes'
#
# [*service_wait_time*]
#   String or Integer.
#   Default: '300'
#
# [*package_name*]
#   String. Name of the yum-cron package.
#   Default: 'yum-cron'
#
# [*service_name*]
#   String. Name of the yum-cron service.
#   Default: 'yum-cron'
#
# [*service_ensure*]
#   Service ensure parameter.
#   Default: 'running'
#
# [*service_enable*]
#   Service enable parameter.
#   Default: true
#
# [*service_hasstatus*]
#   Service hasstatus parameter.
#
# [*service_hasrestart*]
#   Service hasrestart parameter.
#
# [*service_autorestart*]
#   Boolean.
#   Default: true
#
# [*config_path*]
#   Path to the yum-cron configuration file.
#   Default: OS version dependent
#
# [*config_template*]
#   Template used to configure yum-cron.
#   Default: OS version dependent
#
# [*yum_autoupdate_ensure*]
#   String.  Valid values are 'undef', 'UNSET', 'absent', 'disabled'.
#     'absent' will uninstall the yum-autoupdate package.
#     'disabled' will set ENABLED="false" in /etc/sysconfig/yum-autoupdate.
#     'undef' and 'UNSET' will do nothing.
#   This is specific to Scientific Linux.
#   Default: 'disabled'
#
# === Examples
#
#  class { 'yum_cron': }
#
# === Authors
#
# Trey Dockendorf <treydock@gmail.com>
#
# === Copyright
#
# Copyright 2013 Trey Dockendorf
#
class yum_cron (
  $ensure                 = 'present',
  $enable                 = true,
  $download_updates       = true,
  $apply_updates          = false,
  $mail_to                = 'root',
  $system_name            = $::fqdn,
  $days_of_week           = '0123456',
  $package_ensure         = undef,
  $package_name           = $yum_cron::params::package_name,
  $service_name           = $yum_cron::params::service_name,
  $service_ensure         = undef,
  $service_enable         = undef,
  $service_hasstatus      = $yum_cron::params::service_hasstatus,
  $service_hasrestart     = $yum_cron::params::service_hasrestart,
  $config_path            = $yum_cron::params::config_path,
  $yum_autoupdate_ensure  = 'disabled'
) inherits yum_cron::params {

  validate_bool($enable)
  validate_bool($download_updates)
  validate_bool($apply_updates)
  validate_string($mail_to)
  validate_string($system_name)
  validate_string($days_of_week)
  validate_re($yum_autoupdate_ensure, ['^undef', '^UNSET', '^absent', '^disabled'])

  case $ensure {
    'present': {
      $package_ensure_default   = 'present'
      if $enable {
        $service_ensure_default = 'running'
        $service_enable_default = true
        $config_notify          = Service['yum-cron']
      } else {
        $service_ensure_default = 'stopped'
        $service_enable_default = false
        $config_notify          = undef
      }
    }
    'absent': {
      $package_ensure_default = 'absent'
      $service_ensure_default = 'stopped'
      $service_enable_default = false
      $config_notify          = undef
    }
    default: {
      fail('ensure parameter must be present or absent')
    }
  }

  $package_ensure_real = pick($package_ensure, $package_ensure_default)
  $service_ensure_real = pick($service_ensure, $service_ensure_default)
  $service_enable_real = pick($service_enable, $service_enable_default)

  if $apply_updates {
    $apply_updates_str  = 'yes'
    $check_only         = 'no'
  } else {
    $apply_updates_str  = 'no'
    $check_only         = 'yes'
  }

  if $download_updates {
    $download_updates_str = 'yes'
    $download_only        = 'yes'
  } else {
    $download_updates_str = 'no'
    $download_only        = 'no'
  }

  include yum_cron::install
  include yum_cron::config
  include yum_cron::service

  anchor { 'yum_cron::start': }->
  Class['yum_cron::install']->
  Class['yum_cron::config']->
  Class['yum_cron::service']->
  anchor { 'yum_cron::end': }
}
