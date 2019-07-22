require 'spec_helper'
require 'json'
vars = JSON.parse(File.read('/tmp/vars.json'))

shared_examples 'xpack_upgrade::init' do |vars|
  #Test users file, users_roles and roles.yml
  describe file("/etc/elasticsearch/#{vars['es_xpack_conf_subdir']}/users_roles") do
    it { should be_owned_by 'elasticsearch' }
    it { should contain 'admin:es_admin' }
    it { should contain 'power_user:testUser' }
  end

  describe file("/etc/elasticsearch/#{vars['es_xpack_conf_subdir']}/users") do
    it { should be_owned_by 'elasticsearch' }
    it { should contain 'testUser:' }
    it { should contain 'es_admin:' }
  end

  describe 'security roles' do
    it 'should list the security roles' do
      roles = curl_json('http://localhost:9200/_xpack/security/role', username='es_admin', password='changeMeAgain')
      expect(roles.key?('superuser'))
    end
  end

  describe file("/etc/elasticsearch/elasticsearch.yml") do
    if vars['es_major_version'] == '7.x'
      it { should contain 'security.authc.realms.file.file1.order: 0' }
      it { should contain 'security.authc.realms.native.native1.order: 1' }
    else
      it { should contain 'security.authc.realms.file1.order: 0' }
      it { should contain 'security.authc.realms.file1.type: file' }
      it { should contain 'security.authc.realms.native1.order: 1' }
      it { should contain 'security.authc.realms.native1.type: native' }
    end
  end

  #Test contents of role_mapping.yml
  describe file("/etc/elasticsearch/#{vars['es_xpack_conf_subdir']}/role_mapping.yml") do
    it { should be_owned_by 'elasticsearch' }
    it { should contain 'power_user:' }
    it { should contain '- cn=admins,dc=example,dc=com' }
    it { should contain 'user:' }
    it { should contain '- cn=admins,dc=example,dc=com' }
  end

  #check accounts are correct i.e. we can auth and they have the correct roles
  describe 'kibana4_server access check' do
    it 'should be reported as version '+vars['es_version'] do
      command = command('curl -s localhost:9200/ -u kibana4_server:changeMe | grep number')
      expect(command.stdout).to match(vars['es_version'])
      expect(command.exit_status).to eq(0)
    end
  end

  describe 'security users' do
    result = curl_json('http://localhost:9200/_xpack/security/user', username='elastic', password='elasticChanged')
    it 'should have the elastic user' do
      expect(result['elastic']['username']).to eq('elastic')
      expect(result['elastic']['roles']).to eq(['superuser'])
      expect(result['elastic']['enabled']).to eq(true)
    end
    it 'should have the kibana user' do
      expect(result['kibana']['username']).to eq('kibana')
      expect(result['kibana']['roles']).to eq(['kibana_system'])
      expect(result['kibana']['enabled']).to eq(true)
    end
    it 'should have the kibana_server user' do
      expect(result['kibana4_server']['username']).to eq('kibana4_server')
      expect(result['kibana4_server']['roles']).to eq(['kibana4_server'])
      expect(result['kibana4_server']['enabled']).to eq(true)
    end
    it 'should have the logstash user' do
      expect(result['logstash_system']['username']).to eq('logstash_system')
      expect(result['logstash_system']['roles']).to eq(['logstash_system'])
      expect(result['logstash_system']['enabled']).to eq(true)
    end
  end

  describe 'logstash_system access check' do
    it 'should be reported as version '+vars['es_version'] do
      command = command('curl -s localhost:9200/ -u logstash_system:aNewLogstashPassword | grep number')
      expect(command.stdout).to match(vars['es_version'])
      expect(command.exit_status).to eq(0)
    end
  end
end
