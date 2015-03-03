shared_examples 'yum_cron::config' do |facts|
  case facts[:operatingsystemmajrelease]
  when '7'
    it do
      should contain_yum_cron_config('commands/download_updates').with({
        :value  => 'yes',
        :notify => 'Service[yum-cron]',
      })
    end

    it do
      should contain_yum_cron_config('commands/apply_updates').with({
        :value  => 'no',
        :notify => 'Service[yum-cron]',
      })
    end

    it do
      should contain_yum_cron_config('emitters/system_name').with({
        :value  => facts[:fqdn],
        :notify => 'Service[yum-cron]',
      })
    end

    it do
      should contain_yum_cron_config('email/email_to').with({
        :value  => 'root',
        :notify => 'Service[yum-cron]',
      })
    end

    it { should_not contain_shellvar('yum_cron CHECK_ONLY') }
    it { should_not contain_shellvar('yum_cron DOWNLOAD_ONLY') }
    it { should_not contain_shellvar('yum_cron MAILTO') }
    it { should_not contain_shellvar('yum_cron SYSTEMNAME') }
    it { should_not contain_shellvar('yum_cron DAYS_OF_WEEK') }
  when '6'
    it do
      should contain_shellvar('yum_cron CHECK_ONLY').with({
        :ensure   => 'present',
        :target   => '/etc/sysconfig/yum-cron',
        :notify   => 'Service[yum-cron]',
        :variable => 'CHECK_ONLY',
        :value    => 'yes',
      })
    end

    it do
      should contain_shellvar('yum_cron DOWNLOAD_ONLY').with({
        :ensure   => 'present',
        :target   => '/etc/sysconfig/yum-cron',
        :notify   => 'Service[yum-cron]',
        :variable => 'DOWNLOAD_ONLY',
        :value    => 'yes',
      })
    end

    it do
      should contain_shellvar('yum_cron MAILTO').with({
        :ensure   => 'present',
        :target   => '/etc/sysconfig/yum-cron',
        :notify   => 'Service[yum-cron]',
        :variable => 'MAILTO',
        :value    => 'root',
      })
    end

    it do
      should contain_shellvar('yum_cron SYSTEMNAME').with({
        :ensure   => 'present',
        :target   => '/etc/sysconfig/yum-cron',
        :notify   => 'Service[yum-cron]',
        :variable => 'SYSTEMNAME',
        :value    => facts[:fqdn],
      })
    end

    it do
      should contain_shellvar('yum_cron DAYS_OF_WEEK').with({
        :ensure   => 'present',
        :target   => '/etc/sysconfig/yum-cron',
        :notify   => 'Service[yum-cron]',
        :variable => 'DAYS_OF_WEEK',
        :value    => '0123456',
      })
    end

    it { should_not contain_yum_cron_config('commands/download_updates') }
    it { should_not contain_yum_cron_config('commands/apply_updates') }
    it { should_not contain_yum_cron_config('emitters/system_name') }
    it { should_not contain_yum_cron_config('email/email_to') }
  when '5'
    it do
      should contain_shellvar('yum_cron CHECK_ONLY').with({
        :ensure   => 'present',
        :target   => '/etc/sysconfig/yum-cron',
        :notify   => 'Service[yum-cron]',
        :variable => 'CHECK_ONLY',
        :value    => 'yes',
      })
    end

    it do
      should contain_shellvar('yum_cron DOWNLOAD_ONLY').with({
        :ensure   => 'present',
        :target   => '/etc/sysconfig/yum-cron',
        :notify   => 'Service[yum-cron]',
        :variable => 'DOWNLOAD_ONLY',
        :value    => 'yes',
      })
    end

    it { should_not contain_yum_cron_config('commands/download_updates') }
    it { should_not contain_yum_cron_config('commands/apply_updates') }
    it { should_not contain_yum_cron_config('emitters/system_name') }
    it { should_not contain_yum_cron_config('email/email_to') }
    it { should_not contain_shellvar('yum_cron MAILTO') }
    it { should_not contain_shellvar('yum_cron SYSTEMNAME') }
    it { should_not contain_shellvar('yum_cron DAYS_OF_WEEK') }
  end

  context 'ensure => absent' do
    let(:params) {{ :ensure => 'absent' }}
    it { should_not contain_yum_cron_config('commands/download_updates') }
    it { should_not contain_yum_cron_config('commands/apply_updates') }
    it { should_not contain_yum_cron_config('emitters/system_name') }
    it { should_not contain_yum_cron_config('email/email_to') }
    it { should_not contain_shellvar('yum_cron CHECK_ONLY') }
    it { should_not contain_shellvar('yum_cron DOWNLOAD_ONLY') }
    it { should_not contain_shellvar('yum_cron MAILTO') }
    it { should_not contain_shellvar('yum_cron SYSTEMNAME') }
    it { should_not contain_shellvar('yum_cron DAYS_OF_WEEK') }
  end

  if facts[:operatingsystem] =~ /Scientific/
    it do
      should contain_file_line('disable yum-autoupdate').with({
        :path  => '/etc/sysconfig/yum-autoupdate',
        :line  => 'ENABLED=false',
        :match => '^ENABLED=.*',
      })
    end

    context "yum_autoupdate_ensure => 'absent'" do
      let(:params) {{ :yum_autoupdate_ensure => 'absent' }}
      it { should_not contain_file_line('disable yum-autoupdate') }
    end

    context "yum_autoupdate_ensure => 'undef'" do
      let(:params) {{ :yum_autoupdate_ensure => 'undef' }}
      it { should_not contain_file_line('disable yum-autoupdate') }
    end

    context "yum_autoupdate_ensure => 'UNSET'" do
      let(:params) {{ :yum_autoupdate_ensure => 'UNSET' }}
      it { should_not contain_file_line('disable yum-autoupdate') }
    end
  else
    it { should_not contain_file_line('disable yum-autoupdate') }
  end
end
