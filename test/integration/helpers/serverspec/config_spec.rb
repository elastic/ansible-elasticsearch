require 'spec_helper'

shared_examples 'config::init' do |es_version|

  describe user('elasticsearch') do
    it { should exist }
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
    it { should contain 'http.port: 9201' }
    it { should contain 'transport.tcp.port: 9301' }
    it { should contain 'node.data: false' }
    it { should contain 'node.master: true' }
    it { should contain 'discovery.zen.ping.multicast.enabled: false' }
    it { should contain 'cluster.name: custom-cluster' }
    it { should contain 'node.name: node1' }
    it { should contain 'bootstrap.mlockall: true' }
    it { should contain 'discovery.zen.ping.unicast.hosts: localhost:9301' }
    it { should contain 'path.conf: /etc/elasticsearch/node1' }
    it { should contain 'path.data: /opt/elasticsearch/data/localhost-node1' }
    it { should contain 'path.work: /opt/elasticsearch/temp/localhost-node1' }
    it { should contain 'path.logs: /opt/elasticsearch/logs/localhost-node1' }
  end

  #test directories exist
  describe file('/etc/elasticsearch/node1') do
    it { should be_directory }
    it { should be_owned_by 'elasticsearch' }
  end

  describe file('/opt/elasticsearch/data/localhost-node1') do
    it { should be_directory }
    it { should be_owned_by 'elasticsearch' }
  end

  describe file('/opt/elasticsearch/logs/localhost-node1') do
    it { should be_directory }
    it { should be_owned_by 'elasticsearch' }
  end

  describe file('/opt/elasticsearch/temp/localhost-node1') do
    it { should be_directory }
    it { should be_owned_by 'elasticsearch' }
  end

  describe file('/etc/init.d/node1_elasticsearch') do
    it { should be_file }
  end

  #test we started on the correct port was used
  describe command('curl -s "localhost:9201"') do
    #TODO: This is returning an empty string
    #its(:stdout) { should match /\"status\" : 200/ }
    its(:exit_status) { should eq 0 }
  end

  #test to make sure mlock was applied
  describe command('curl -s "localhost:9201/_nodes/process?pretty" | grep mlockall') do
    its(:stdout) { should match /true/ }
    its(:exit_status) { should eq 0 }
  end


  describe 'version check' do
    it 'should be reported as version '+es_version do
      command = command('curl -s localhost:9201 | grep number')
      expect(command.stdout).to match(es_version)
      expect(command.exit_status).to eq(0)
    end
  end

  #Not copied on Debian 8
  #describe file('/usr/lib/systemd/system/node1_elasticsearch.service') do
  #  it { should be_file }
  #  it { should contain 'LimitMEMLOCK=infinity' }
  #end

end

