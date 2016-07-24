require 'spec_helper'

shared_examples 'xpack::init' do |es_version|

  describe user('elasticsearch') do
    it { should exist }
  end

  describe service('shield_node_elasticsearch') do
    it { should be_running }
  end

  describe package('elasticsearch') do
    it { should be_installed }
  end

  describe file('/etc/elasticsearch/shield_node/elasticsearch.yml') do
    it { should be_file }
    it { should be_owned_by 'elasticsearch' }
  end

  describe file('/etc/elasticsearch/shield_node/logging.yml') do
    it { should be_file }
    it { should be_owned_by 'elasticsearch' }
  end

  describe file('/etc/elasticsearch/shield_node/elasticsearch.yml') do
    it { should contain 'node.name: localhost-shield_node' }
    it { should contain 'cluster.name: elasticsearch' }
    it { should contain 'path.conf: /etc/elasticsearch/shield_node' }
    it { should contain 'path.data: /var/lib/elasticsearch/localhost-shield_node' }
    it { should contain 'path.work: /tmp/elasticsearch/localhost-shield_node' }
    it { should contain 'path.logs: /var/log/elasticsearch/localhost-shield_node' }
  end

  describe 'Node listening' do
    it 'listening in port 9200' do
      expect(port 9200).to be_listening
    end
  end

  describe 'version check' do
    it 'should be reported as version '+es_version do
      command = command('curl -s localhost:9200 -u es_admin:changeMe | grep number')
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

  #Xpack specific tests
  describe file('/usr/share/elasticsearch/plugins') do
    it { should be_directory }
    it { should be_owned_by 'elasticsearch' }
  end


  #Check shield and license plugins are installed
  describe file('/usr/share/elasticsearch/plugins/license') do
    it { should be_directory }
    it { should be_owned_by 'elasticsearch' }
  end

  describe command('curl -s localhost:9200/_nodes/plugins?pretty=true -u es_admin:changeMe | grep license') do
    its(:exit_status) { should eq 0 }
  end

  describe file('/usr/share/elasticsearch/plugins/shield') do
    it { should be_directory }
    it { should be_owned_by 'elasticsearch' }
  end

  describe command('curl -s localhost:9200/_nodes/plugins?pretty=true -u es_admin:changeMe | grep shield') do
    its(:exit_status) { should eq 0 }
  end

  describe file('/etc/elasticsearch/shield_node/shield') do
    it { should be_directory }
    it { should be_owned_by 'elasticsearch' }
  end


  #Test users file, users_roles and roles.yml
  describe file('/etc/elasticsearch/shield_node/shield/users_roles') do
    it { should be_owned_by 'elasticsearch' }
    it { should contain 'admin:es_admin' }
    it { should contain 'power_user:testUser' }
  end

  describe file('/etc/elasticsearch/shield_node/shield/users') do
    it { should be_owned_by 'elasticsearch' }
    it { should contain 'testUser:' }
    it { should contain 'es_admin:' }
  end


  describe file('/etc/elasticsearch/shield_node/shield/roles.yml') do
    it { should be_owned_by 'elasticsearch' }
    #Test contents as expected
    its(:md5sum) { should eq '7800182547287abd480c8b095bf26e9e' }
  end


  #Test native roles and users are loaded
  describe command('curl -s localhost:9200/_shield/user -u es_admin:changeMe | md5sum | grep 557a730df7136694131b5b7012a5ffad') do
    its(:exit_status) { should eq 0 }
  end

  describe command('curl -s localhost:9200/_shield/user -u es_admin:changeMe | grep "{\"kibana4_server\":{\"username\":\"kibana4_server\",\"roles\":\[\"kibana4_server\"\],\"full_name\":null,\"email\":null,\"metadata\":{}}}"') do
    its(:exit_status) { should eq 0 }
  end

  describe command('curl -s localhost:9200/_shield/role -u es_admin:changeMe | grep "{\"logstash\":{\"cluster\":\[\"manage_index_templates\"\],\"indices\":\[{\"names\":\[\"logstash-\*\"\],\"privileges\":\[\"write\",\"delete\",\"create_index\"\]}\],\"run_as\":\[\]}}"') do
    its(:exit_status) { should eq 0 }
  end

  describe command('curl -s localhost:9200/_shield/role -u es_admin:changeMe | md5sum | grep 6d14f09ef1eea64adf4d4a9c04229629') do
    its(:exit_status) { should eq 0 }
  end

  describe file('/etc/elasticsearch/templates') do
    it { should be_directory }
    it { should be_owned_by 'elasticsearch' }
  end

  describe file('/etc/elasticsearch/templates/basic.json') do
    it { should be_file }
    it { should be_owned_by 'elasticsearch' }
  end

  describe 'Template Installed' do
    it 'should be reported as being installed', :retry => 3, :retry_wait => 10 do
      command = command('curl -s "localhost:9200/_template/basic" -u es_admin:changeMe')
      expect(command.stdout).to match(/basic/)
      expect(command.exit_status).to eq(0)
    end
  end

  #Test contents of Elasticsearch.yml file
  describe file('/etc/elasticsearch/shield_node/elasticsearch.yml') do
    it { should contain 'shield.authc.realms.file1.order: 0' }
    it { should contain 'shield.authc.realms.file1.type: file' }
    it { should contain 'shield.authc.realms.native1.order: 1' }
    it { should contain 'shield.authc.realms.native1.type: native' }
  end

end

