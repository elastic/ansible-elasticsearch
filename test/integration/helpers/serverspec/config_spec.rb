require 'spec_helper'

shared_examples 'config::init' do |es_version,plugins|

  describe user('elasticsearch') do
    it { should exist }
  end
  
  describe group('elasticsearch') do
    it { should have_gid 333 }
  end

  describe user('elasticsearch') do
    it { should have_uid 333 }
  end

  describe service('node1_elasticsearch') do
    it { should be_running }
  end

  describe package('elasticsearch') do
    it { should be_installed }
  end

  describe file('/etc/elasticsearch/node1/elasticsearch.yml') do
    it { should be_file }
  end

  #test configuration parameters have been set - test all appropriately set in config file
  describe file('/etc/elasticsearch/node1/elasticsearch.yml') do
    it { should contain 'http.port: 9401' }
    it { should contain 'transport.tcp.port: 9501' }
    it { should contain 'node.data: true' }
    it { should contain 'node.master: true' }
    it { should contain 'cluster.name: custom-cluster' }
    it { should contain 'node.name: node1' }
    it { should contain 'bootstrap.memory_lock: true' }
    it { should contain 'discovery.zen.ping.unicast.hosts: localhost:9501' }
    it { should contain 'path.conf: /etc/elasticsearch/node1' }
    it { should contain 'path.data: /opt/elasticsearch/data-1/localhost-node1,/opt/elasticsearch/data-2/localhost-node1' }
    it { should contain 'path.logs: /opt/elasticsearch/logs/localhost-node1' }
  end

  #test directories exist
  describe file('/etc/elasticsearch/node1') do
    it { should be_directory }
    it { should be_owned_by 'elasticsearch' }
  end

  describe file('/opt/elasticsearch/data-1/localhost-node1') do
    it { should be_directory }
    it { should be_owned_by 'elasticsearch' }
  end

  describe file('/opt/elasticsearch/data-2/localhost-node1') do
    it { should be_directory }
    it { should be_owned_by 'elasticsearch' }
  end

  describe file('/opt/elasticsearch/logs/localhost-node1') do
    it { should be_directory }
    it { should be_owned_by 'elasticsearch' }
  end

  #test we started on the correct port was used
  describe command('curl -s "localhost:9401"') do
    #TODO: This is returning an empty string
    #its(:stdout) { should match /\"status\" : 200/ }
    its(:exit_status) { should eq 0 }
  end

  #test to make sure mlock was applied
  describe command('curl -s "localhost:9401/_nodes/process?pretty" | grep mlockall') do
    its(:stdout) { should match /true/ }
    its(:exit_status) { should eq 0 }
  end


  describe 'version check' do
    it 'should be reported as version '+es_version do
      command = command('curl -s localhost:9401 | grep number')
      expect(command.stdout).to match(es_version)
      expect(command.exit_status).to eq(0)
    end
  end

  for plugin in plugins
    describe file('/usr/share/elasticsearch/plugins/'+plugin) do
      it { should be_directory }
      it { should be_owned_by 'elasticsearch' }
    end
    #confirm plugins are installed and the correct version
    describe command('curl -s localhost:9401/_nodes/plugins | grep \'"name":"'+plugin+'","version":"'+es_version+'"\'') do
      its(:exit_status) { should eq 0 }
    end
  end

  #explit test to make sure ingest-geoip is not installed
  describe file('/usr/share/elasticsearch/plugins/ingest-geoip') do
    it { should_not exist }
  end
  #confirm plugins are installed and the correct version
  describe command('curl -s localhost:9200/_nodes/plugins | grep \'"name":"ingest-geoip","version":"'+es_version+'"\'') do
    its(:exit_status) { should eq 1 }
  end

  describe file('/etc/init.d/elasticsearch') do
    it { should_not exist }
  end

  describe file('/etc/default/elasticsearch') do
    it { should_not exist }
  end

  describe file('/etc/sysconfig/elasticsearch') do
    it { should_not exist }
  end

  describe file('/usr/lib/systemd/system/elasticsearch.service') do
    it { should_not exist }
  end

  describe file('/etc/elasticsearch/elasticsearch.yml') do
    it { should_not exist }
  end

  describe file('/etc/elasticsearch/logging.yml') do
    it { should_not exist }
  end

  #Init vs Systemd tests
  #Ubuntu 15 and up
  #Debian 8 and up
  #Centos 7 and up

  if (((os[:family] == 'redhat' || os[:family] == 'centos') && os[:release].to_f >= 7.0) ||
      (os[:family] == 'ubuntu' && os[:release].to_f >= 15.0) ||
      (os[:family] == 'debian' && os[:release].to_f >= 8.0))
    describe file('/usr/lib/systemd/system/node1_elasticsearch.service') do
      it { should be_file }
      it { should contain 'LimitMEMLOCK=infinity' }
      it { should contain 'LimitNPROC=3000' }
    end
  else
    describe file('/etc/init.d/node1_elasticsearch') do
      it { should be_file }
    end
  end

  describe file('/etc/elasticsearch/node1/log4j2.properties') do
    it { should be_file }
    it { should be_owned_by 'elasticsearch' }
    it { should contain 'CUSTOM LOG4J FILE' }
  end


end

