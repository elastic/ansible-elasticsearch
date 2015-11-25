require 'spec_helper'

context "basic tests" do

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
    it { should contain 'path.data: /var/lib/elasticsearch/localhost-node1' }
    it { should contain 'path.work: /tmp/elasticsearch/localhost-node1' }
    it { should contain 'path.logs: /var/log/elasticsearch/localhost-node1' }
  end

  #test we started on the correct port was used
  describe command('curl "localhost:9201" | grep status') do
    #TODO: This is returning an empty string
    #its(:stdout) { should match /\"status\" : 200/ }
    its(:exit_status) { should eq 0 }
  end


end

