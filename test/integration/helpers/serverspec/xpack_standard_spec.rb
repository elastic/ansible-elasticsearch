require 'spec_helper'

shared_examples 'xpack_standard::init' do |vars|

  describe user('elasticsearch') do
    it { should exist }
  end

  describe service('security_node_elasticsearch') do
    it { should be_running }
  end

  describe package('elasticsearch') do
    it { should be_installed }
  end

  describe file('/etc/elasticsearch/security_node/elasticsearch.yml') do
    it { should be_file }
    it { should be_owned_by 'elasticsearch' }
  end

  describe file('/etc/elasticsearch/security_node/log4j2.properties') do
    it { should be_file }
    it { should be_owned_by 'elasticsearch' }
  end

  describe file('/etc/elasticsearch/security_node/elasticsearch.yml') do
    it { should contain 'node.name: localhost-security_node' }
    it { should contain 'cluster.name: elasticsearch' }
    if vars['es_major_version'] == '6.x'
      it { should_not contain 'path.conf: /etc/elasticsearch/security_node' }
    else
      it { should contain 'path.conf: /etc/elasticsearch/security_node' }
    end
    it { should contain 'path.data: /var/lib/elasticsearch/localhost-security_node' }
    it { should contain 'path.logs: /var/log/elasticsearch/localhost-security_node' }
    it { should contain 'xpack.security.enabled: false' }
    it { should contain 'xpack.watcher.enabled: false' }

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

  #Xpack specific tests
  describe file('/usr/share/elasticsearch/plugins') do
    it { should be_directory }
    it { should be_owned_by 'elasticsearch' }
  end

  #Test if x-pack is activated
  describe 'x-pack activation' do
    it 'should be activated and valid' do
      command = command('curl -s localhost:9200/_license?pretty=true')
      expect(command.stdout).to match('"status" : "active"')
      expect(command.exit_status).to eq(0)
    end
  end

  describe file('/usr/share/elasticsearch/plugins/x-pack') do
    it { should be_directory }
    it { should be_owned_by 'elasticsearch' }
  end

  describe command('curl -s localhost:9200/_nodes/plugins?pretty=true -u es_admin:changeMeAgain | grep x-pack') do
    its(:exit_status) { should eq 0 }
  end

  describe file('/etc/elasticsearch/security_node/x-pack') do
    it { should be_directory }
    it { should be_owned_by 'elasticsearch' }
  end

  describe file('/usr/share/elasticsearch/plugins/x-pack') do
    it { should be_directory }
    it { should be_owned_by 'elasticsearch' }
  end

  describe file('/usr/share/elasticsearch/plugins/x-pack') do
    it { should be_directory }
    it { should be_owned_by 'elasticsearch' }
  end

  describe 'x-pack-core plugin' do
    it 'should be installed with the correct version' do
      plugins = curl_json('http://localhost:9200/_nodes/plugins')
      node, data = plugins['nodes'].first
      version = 'plugin not found'

      if Gem::Version.new(vars['es_version']) >= Gem::Version.new('6.2')
        name = 'x-pack-core'
      else
        name = 'x-pack'
      end

      data['plugins'].each do |plugin|
        if plugin['name'] == name
          version = plugin['version']
        end
      end
      expect(version).to eql(vars['es_version'])
    end
  end

  #Test users file, users_roles and roles.yml
  describe file('/etc/elasticsearch/security_node/x-pack/users_roles') do
    it { should be_owned_by 'elasticsearch' }
  end

  describe file('/etc/elasticsearch/security_node/x-pack/users') do
    it { should be_owned_by 'elasticsearch' }
  end

  describe command('curl -s localhost:9200/_xpack') do
    its(:stdout_as_json) { should include('features' => include('security' => include('enabled' => false))) }
    its(:stdout_as_json) { should include('features' => include('watcher' => include('enabled' => false))) }
    its(:stdout_as_json) { should include('features' => include('graph' => include('enabled' => true))) }
    its(:stdout_as_json) { should include('features' => include('monitoring' => include('enabled' => true))) }
    its(:stdout_as_json) { should include('features' => include('ml' => include('enabled' => true))) }
  end

end

