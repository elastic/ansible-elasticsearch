require 'spec_helper'

shared_examples 'standard::init' do |es_version,plugins|

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
    it { should be_owned_by 'elasticsearch' }
  end

  describe file('/etc/elasticsearch/node1/log4j2.properties') do
    it { should be_file }
    it { should be_owned_by 'elasticsearch' }
    it { should_not contain 'CUSTOM LOG4J FILE' }
  end

  describe file('/etc/elasticsearch/node1/jvm.options') do
    it { should be_file }
    it { should be_owned_by 'elasticsearch' }
  end

  describe file('/etc/elasticsearch/node1/elasticsearch.yml') do
    it { should contain 'node.name: localhost-node1' }
    it { should contain 'cluster.name: elasticsearch' }
    it { should contain 'path.conf: /etc/elasticsearch/node1' }
    it { should contain 'path.data: /var/lib/elasticsearch/localhost-node1' }
    it { should contain 'path.logs: /var/log/elasticsearch/localhost-node1' }
  end

  describe 'Node listening' do
    it 'listening in port 9200' do
      expect(port 9200).to be_listening
    end
  end

  describe 'version check' do
    it 'should be reported as version '+es_version do
      command = command('curl -s localhost:9200 | grep number')
      expect(command.stdout).to match(es_version)
      expect(command.exit_status).to eq(0)
    end
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

  for plugin in plugins
    describe file('/usr/share/elasticsearch/plugins/'+plugin) do
      it { should be_directory }
      it { should be_owned_by 'elasticsearch' }
    end
    #confirm plugins are installed and the correct version
    describe command('curl -s localhost:9200/_nodes/plugins | grep \'"name":"'+plugin+'","version":"'+es_version+'"\'') do
      its(:exit_status) { should eq 0 }
    end
  end


end

