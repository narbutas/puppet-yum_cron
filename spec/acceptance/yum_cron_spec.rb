require 'spec_helper_acceptance'

describe 'yum_cron class:' do
  context 'with default parameters' do
    it 'should run successfully' do
      pp = "class { 'yum_cron': }"

      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)
    end

    describe package('yum-cron') do
      it { should be_installed }
    end

    describe service('yum-cron') do
      it { should be_enabled }
      it { should be_running }
    end

    if fact('operatingsystemmajrelease') < '7'
      describe file('/etc/sysconfig/yum-cron') do
        its(:content) { should match /^CHECK_ONLY=yes$/ }
        its(:content) { should match /^DOWNLOAD_ONLY=yes$/ }
        if fact('operatingsystemmajrelease') == '6'
          its(:content) { should match /^MAILTO=root$/ }
          its(:content) { should match /^SYSTEMNAME=#{fact('fqdn')}$/ }
          its(:content) { should match /^DAYS_OF_WEEK=0123456$/ }
        end
      end
    end

    if fact('operatingsystemmajrelease') == '7'
      describe file('/etc/yum/yum-cron.conf') do
        its(:content) { should match /^download_updates = yes$/ }
        its(:content) { should match /^apply_updates = no$/ }
        its(:content) { should match /^system_name = #{fact('fqdn')}$/ }
        its(:content) { should match /^email_to = root$/ }
      end
    end

    if fact('operatingsystem') =~ /Scientific/
      describe package('yum-autoupdate') do
        it { should be_installed }
      end

      describe file('/etc/sysconfig/yum-autoupdate') do
        its(:content) { should match /^ENABLED=false$/ }
      end
    end
  end

  if fact('operatingsystem') =~ /Scientific/
    context "with yum_autoupdate_ensure => 'absent'" do
      it 'should remove yum-autoupdate' do
        pp = "class { 'yum_cron': yum_autoupdate_ensure => 'absent' }"

        apply_manifest(pp, :catch_failures => true)
        apply_manifest(pp, :catch_changes => true)
      end
        
      describe package('yum-autoupdate') do
        it { should_not be_installed }
      end
    end
  end
end
