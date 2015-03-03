# Private class
class yum_cron::config {
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  if $yum_cron::ensure == 'present' {
    if $::operatingsystemmajrelease >= '7' {
      Yum_cron_config {
        notify => $yum_cron::config_notify,
      }

      yum_cron_config { 'commands/download_updates': value => $yum_cron::download_updates_str }
      yum_cron_config { 'commands/apply_updates': value => $yum_cron::apply_updates_str }
      yum_cron_config { 'emitters/system_name': value => $yum_cron::system_name }
      yum_cron_config { 'email/email_to': value => $yum_cron::mail_to }
    }

    if $::operatingsystemmajrelease < '7' {
      Shellvar {
        ensure => present,
        target => $yum_cron::config_path,
        notify => $yum_cron::config_notify,
      }

      shellvar { 'yum_cron CHECK_ONLY':
        variable => 'CHECK_ONLY',
        value    => $yum_cron::check_only,
      }

      shellvar { 'yum_cron DOWNLOAD_ONLY':
        variable => 'DOWNLOAD_ONLY',
        value    => $yum_cron::download_only,
      }

      if $::operatingsystemmajrelease == '6' {
        shellvar { 'yum_cron MAILTO':
          variable => 'MAILTO',
          value    => $yum_cron::mail_to,
        }

        shellvar { 'yum_cron SYSTEMNAME':
          variable => 'SYSTEMNAME',
          value    => $yum_cron::system_name,
        }

        shellvar { 'yum_cron DAYS_OF_WEEK':
          variable => 'DAYS_OF_WEEK',
          value    => $yum_cron::days_of_week,
        }
      }
    }

    if $::operatingsystem =~ /Scientific/ and $yum_cron::yum_autoupdate_ensure == 'disabled' {
      file_line { 'disable yum-autoupdate':
        path  => '/etc/sysconfig/yum-autoupdate',
        line  => 'ENABLED=false',
        match => '^ENABLED=.*',
      }
    }
  }
}
