require 'spec_helper'
require 'json'
vars = JSON.parse(File.read('/tmp/vars.json'))

shared_examples 'xpack::init' do |vars|

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
  end

  describe 'Node listening' do
    it 'listening in port 9200' do
      expect(port 9200).to be_listening
    end
  end

  describe 'version check' do
    it 'should be reported as version '+vars['es_version'] do
      command = command('curl -s localhost:9200 -u es_admin:changeMeAgain | grep number')
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
      command = command('curl -s localhost:9200/_license?pretty=true -u es_admin:changeMeAgain')
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

  for plugin in vars['es_plugins']
    plugin = plugin['plugin']

    describe file('/usr/share/elasticsearch/plugins/'+plugin) do
      it { should be_directory }
      it { should be_owned_by 'elasticsearch' }
    end

    describe command('curl -s localhost:9200/_nodes/plugins -u es_admin:changeMeAgain | grep \'"name":"'+plugin+'","version":"'+vars['es_version']+'"\'') do
      its(:exit_status) { should eq 0 }
    end
  end

  #Test users file, users_roles and roles.yml
  describe file('/etc/elasticsearch/security_node/x-pack/users_roles') do
    it { should be_owned_by 'elasticsearch' }
    it { should contain 'admin:es_admin' }
    it { should contain 'power_user:testUser' }
  end

  describe file('/etc/elasticsearch/security_node/x-pack/users') do
    it { should be_owned_by 'elasticsearch' }
    it { should contain 'testUser:' }
    it { should contain 'es_admin:' }
  end


  describe file('/etc/elasticsearch/security_node/x-pack/roles.yml') do
    it { should be_owned_by 'elasticsearch' }
    #Test contents as expected
    its(:md5sum) { should eq '7800182547287abd480c8b095bf26e9e' }
  end


  #Test native roles and users are loaded
  describe command('curl -s localhost:9200/_xpack/security/user -u es_admin:changeMeAgain | md5sum | grep b6a1293c343e745a508c74778c9be8bb') do
    its(:exit_status) { should eq 0 }
  end

  describe 'security roles' do
    it 'should list the security roles' do
      roles = curl_json('http://localhost:9200/_xpack/security/role', username='es_admin', password='changeMeAgain')
      expect(roles.key?('superuser'))
    end
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
      command = command('curl -s "localhost:9200/_template/basic" -u es_admin:changeMeAgain')
      expect(command.stdout).to match(/basic/)
      expect(command.exit_status).to eq(0)
    end
  end

  #This is possibly subject to format changes in the response across versions so may fail in the future
  describe 'Template Contents Correct' do
    it 'should be reported as being installed', :retry => 3, :retry_wait => 10 do
      template = curl_json('http://localhost:9200/_template/basic', username='es_admin', password='changeMeAgain')
      expect(template.key?('basic'))
      expect(template['basic']['settings']['index']['number_of_shards']).to eq("1")
      expect(template['basic']['mappings']['type1']['_source']['enabled']).to eq(false)
    end
  end

  #Test contents of Elasticsearch.yml file
  describe file('/etc/elasticsearch/security_node/elasticsearch.yml') do
    it { should contain 'security.authc.realms.file1.order: 0' }
    it { should contain 'security.authc.realms.file1.type: file' }
    it { should contain 'security.authc.realms.native1.order: 1' }
    it { should contain 'security.authc.realms.native1.type: native' }
  end

  #Test contents of role_mapping.yml
  describe file('/etc/elasticsearch/security_node/x-pack/role_mapping.yml') do
    it { should be_owned_by 'elasticsearch' }
    it { should contain 'power_user:' }
    it { should contain '- cn=admins,dc=example,dc=com' }
    it { should contain 'user:' }
    it { should contain '- cn=admins,dc=example,dc=com' }
  end


  describe file('/etc/elasticsearch/security_node/x-pack/system_key') do
    it { should be_owned_by 'elasticsearch' }
    it { should be_writable.by('owner') }
    it { should be_writable.by_user('elasticsearch') }
    it { should be_readable.by('owner') }
    it { should be_readable.by_user('elasticsearch') }
    it { should_not be_executable }
    #Test contents as expected
    its(:md5sum) { should eq '6ff0e6c4380a6ac0f6e04d871c0ca5e8' }
  end

  #check accounts are correct i.e. we can auth and they have the correct roles

  describe 'kibana4_server access check' do
    it 'should be reported as version '+vars['es_version'] do
      command = command('curl -s localhost:9200/ -u kibana4_server:changeMe | grep number')
      expect(command.stdout).to match(vars['es_version'])
      expect(command.exit_status).to eq(0)
    end
  end

  describe command('curl -s localhost:9200/_xpack/security/user/kibana4_server -u elastic:elasticChanged | md5sum | grep f0548742161d9e50c7c7fbe2e061a1fa') do
      its(:exit_status) { should eq 0 }
  end


  describe 'logstash_system access check' do
    it 'should be reported as version '+vars['es_version'] do
      command = command('curl -s localhost:9200/ -u logstash_system:aNewLogstashPassword | grep number')
      expect(command.stdout).to match(vars['es_version'])
      expect(command.exit_status).to eq(0)
    end
  end

  describe command('curl -s localhost:9200/_xpack/security/user/logstash_system -u elastic:elasticChanged | md5sum | grep 98d361ddfa5156abd33542a493b4fd85') do
      its(:exit_status) { should eq 0 }
  end

  if vars['es_major_version'] == '5.x' # kibana default password has been removed in 6.x
    describe 'kibana access check' do
      it 'should be reported as version '+vars['es_version'] do
        result = curl_json('http://localhost:9200/', username='kibana', password='changeme')
        expect(result['version']['number']).to eq(vars['es_version'])
      end
    end
  end

  describe command('curl -s localhost:9200/_xpack/security/user/kibana -u elastic:elasticChanged | md5sum | grep 34190c64eb3c7cfb002fa789df5fad20') do
      its(:exit_status) { should eq 0 }
  end

end

