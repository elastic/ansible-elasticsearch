require 'spec_helper'
require 'json'
require 'pathname'
vars = JSON.parse(File.read('/tmp/vars.json'))

es_api_url = "#{vars['es_api_scheme']}://localhost:#{vars['es_api_port']}"
username = vars['es_api_basic_auth_username']
password = vars['es_api_basic_auth_password']
es_keystore = Pathname.new(vars['es_ssl_keystore']).basename.to_s
es_truststore = Pathname.new(vars['es_ssl_truststore']).basename.to_s

if vars['es_major_version'] == '7.x'
  es_security_api = "_security"
else
  es_security_api = "_xpack/security"
end

shared_examples 'xpack_upgrade::init' do |vars|
  #Test users file, users_roles and roles.yml
  describe file("/etc/elasticsearch/users_roles") do
    it { should be_owned_by 'root' }
    it { should contain 'admin:es_admin' }
    it { should contain 'power_user:testUser' }
  end

  describe file("/etc/elasticsearch/users") do
    it { should be_owned_by 'root' }
    it { should contain 'testUser:' }
    it { should contain 'es_admin:' }
  end

  describe 'security roles' do
    it 'should list the security roles' do
      roles = curl_json("#{es_api_url}/#{es_security_api}/role", username='es_admin', password='changeMeAgain')
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
    it { should contain 'xpack.security.transport.ssl.enabled: true' }
    it { should contain 'xpack.security.http.ssl.enabled: true' }
    it { should contain es_keystore }
    it { should contain es_truststore }
  end

  #Test contents of role_mapping.yml
  describe file("/etc/elasticsearch/role_mapping.yml") do
    it { should be_owned_by 'root' }
    it { should contain 'power_user:' }
    it { should contain '- cn=admins,dc=example,dc=com' }
    it { should contain 'user:' }
    it { should contain '- cn=admins,dc=example,dc=com' }
  end

  #check accounts are correct i.e. we can auth and they have the correct roles
  describe 'kibana4_server access check' do
    it 'should be reported as version '+vars['es_version'] do
      expect(curl_json(es_api_url, username='kibana4_server', password='changeMe')['version']['number']).to eq(vars['es_version'])
    end
  end

  describe 'security users' do
    result = curl_json("#{es_api_url}/#{es_security_api}/user", username=username, password=password)
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
      expect(curl_json(es_api_url, username='logstash_system', password='aNewLogstashPassword')['version']['number']).to eq(vars['es_version'])
    end
  end

  describe 'SSL certificate check' do
    certificates = curl_json("#{es_api_url}/_ssl/certificates", username=username, password=password)
    it 'should list the keystore file' do
      expect(certificates.any? { |cert| cert['path'].include? es_keystore }).to be true
    end
    it 'should list the truststore file' do
      expect(certificates.any? { |cert| cert['path'].include? es_truststore }).to be true
    end
  end
end
