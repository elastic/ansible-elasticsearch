require 'spec_helper'

shared_examples 'standard::init' do |vars|

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
    if vars['es_major_version'] == '6.x'
      it { should_not contain 'path.conf: /etc/elasticsearch/node1' }
    else
      it { should contain 'path.conf: /etc/elasticsearch/node1' }
    end
    it { should contain 'path.data: /var/lib/elasticsearch/localhost-node1' }
    it { should contain 'path.logs: /var/log/elasticsearch/localhost-node1' }
  end

  describe 'Node listening' do
    it 'listening in port 9200' do
      expect(port 9200).to be_listening
    end
  end

  describe 'version check' do
    it 'should be reported as version '+vars['es_version'] do
      command = command('curl -s localhost:9200 | grep number')
      expect(command.stdout).to match(vars['es_version'])
      expect(command.exit_status).to eq(0)
    end
  end

  describe file('/etc/init.d/elasticsearch') do
    it { should_not exist }
  end

  if ['debian', 'ubuntu'].include?(os[:family])
    describe file('/etc/default/elasticsearch') do
      its(:content) { should match '' }
    end
  end

  if ['centos', 'redhat'].include?(os[:family])
    describe file('/etc/sysconfig/elasticsearch') do
      its(:content) { should match '' }
    end
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

  for plugin in vars['es_plugins']
    plugin = plugin['plugin']

    describe file('/usr/share/elasticsearch/plugins/'+plugin) do
      it { should be_directory }
      it { should be_owned_by 'elasticsearch' }
    end
    #confirm plugins are installed and the correct version
    describe command('curl -s localhost:9200/_nodes/plugins | grep \'"name":"'+plugin+'","version":"'+vars['es_version']+'"\'') do
      its(:exit_status) { should eq 0 }
    end
  end


end

