require 'spec_helper'

context "basic tests" do

  describe user('elasticsearch') do
    it { should exist }
  end

  describe service('node1_elasticsearch') do
    it { should be_running }
  end

  describe service('master_elasticsearch') do
    it { should be_running }
  end

  describe package('elasticsearch') do
    it { should be_installed }
  end

  describe file('/etc/elasticsearch/node1_elasticsearch/elasticsearch.yml') do
    it { should be_file }
  end

  describe file('/etc/elasticsearch/master_elasticsearch/elasticsearch.yml') do
    it { should be_file }
  end

  #test configuration parameters have been set - test all appropriately set in config file
  describe file('/etc/elasticsearch/node1_elasticsearch/elasticsearch.yml') do
    it { should contain 'http.port: 9201' }
    it { should contain 'transport.tcp.port: 9301' }
    it { should contain 'node.data: true' }
    it { should contain 'node.master: false' }
    it { should contain 'discovery.zen.ping.multicast.enabled: false' }
    it { should contain 'node.name: node1_localhost' }
  end


  #test configuration parameters have been set for master - test all appropriately set in config file
  describe file('/etc/elasticsearch/master_elasticsearch/elasticsearch.yml') do
    it { should contain 'http.port: 9200' }
    it { should contain 'transport.tcp.port: 9300' }
    it { should contain 'node.data: false' }
    it { should contain 'node.master: true' }
    it { should contain 'discovery.zen.ping.multicast.enabled: false' }
    it { should contain 'node.name: master_localhost' }
  end

  describe 'Master listening' do
    it 'listening in port 9200' do
      expect(port 9200).to be_listening
    end
  end

  describe 'Node listening' do
    it 'node should be listening in port 9201' do
      expect(port 9201).to be_listening
    end
  end

  #test we started on the correct port was used for master
  describe 'master started' do
    it 'master node should be running', :retry => 3, :retry_wait => 10 do
      command = command('curl "localhost:9200" | grep name')
      #expect(command.stdout).should match '/*master_localhost*/'
      expect(command.exit_status).to eq(0)
    end
  end

  #test we started on the correct port was used for node 1
  describe 'node1 started' do
    it 'node should be running', :retry => 3, :retry_wait => 10 do
      command = command('curl "localhost:9201" | grep name')
      #expect(command.stdout).should match '/*node1_localhost*/'
      expect(command.exit_status).to eq(0)
    end
  end

end

