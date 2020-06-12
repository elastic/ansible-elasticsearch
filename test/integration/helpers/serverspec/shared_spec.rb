require 'spec_helper'
require 'json'
vars = JSON.parse(File.read('/tmp/vars.json'))

$families = {
  'Debian' => {
    'shell'    => '/bin/false',
    'password' => '*',
    'defaults_path' => '/etc/default/elasticsearch'
  },
  'RedHat' => {
    'shell'    => '/sbin/nologin',
    'password' => '!!',
    'defaults_path' => '/etc/sysconfig/elasticsearch'
  }
}

$family = $families[vars['ansible_os_family']]

es_api_url = "#{vars['es_api_scheme']}://localhost:#{vars['es_api_port']}"
username = vars['es_api_basic_auth_username']
password = vars['es_api_basic_auth_password']

# Sample of default features status
features = {
  'monitoring' => {
    'enabled' => 'true',
    'available' => 'true'
  },
  'ml' => {
    'enabled' => 'true',
    'available' => 'false'
  },
  'sql' => {
    'enabled' => 'true',
    'available' => 'true'
  }
}

shared_examples 'shared::init' do |vars|
  describe 'version check' do
    it 'should be reported as version '+vars['es_version'] do
      expect(curl_json(es_api_url, username=username, password=password)['version']['number']).to eq(vars['es_version'])
    end
  end
  describe 'xpack checks' do
    if not vars['oss_version']
      it 'should be be running the basic version' do
        expect(curl_json("#{es_api_url}/_xpack", username=username, password=password)['tagline']).to eq('You know, for X')
      end
      it 'xpack should be activated' do
        expect(curl_json("#{es_api_url}/_license", username=username, password=password)['license']['status']).to eq('active')
      end
    end
  end
  describe user(vars['es_user']) do
    it { should exist }
    it { should belong_to_group vars['es_group'] }
    it { should have_uid vars['es_user_id'] } if vars.key?('es_user_id')

    it { should have_login_shell $family['shell'] }

    its(:encrypted_password) { should eq($family['password']) }
  end

  describe package(vars['es_package_name']) do
    it { should be_installed }
  end

  describe service("elasticsearch") do
    it { should be_running }
  end

  describe port(vars['es_api_port']) do
    it { should be_listening.with('tcp') }
  end

  if vars['es_templates']
    describe file('/etc/elasticsearch/templates') do
      it { should be_directory }
      it { should be_owned_by 'root' }
    end
    describe file('/etc/elasticsearch/templates/basic.json') do
      it { should be_file }
      it { should be_owned_by 'root' }
    end
    #This is possibly subject to format changes in the response across versions so may fail in the future
    describe 'Template Contents Correct' do
      it 'should be reported as being installed', :retry => 3, :retry_wait => 10 do
        template = curl_json("#{es_api_url}/_template/basic", username=username, password=password)
        expect(template.key?('basic'))
        expect(template['basic']['settings']['index']['number_of_shards']).to eq("1")
        if vars['es_major_version'] == '7.x'
          expect(template['basic']['mappings']['_source']['enabled']).to eq(false)
        else
          expect(template['basic']['mappings']['type1']['_source']['enabled']).to eq(false)
        end
      end
    end
  end

  describe file($family['defaults_path']) do
    its(:content) { should match '' }
  end

  if vars.key?('es_plugins')
    vars['es_plugins'].each do |plugin|
      name = plugin['plugin']
      describe file('/usr/share/elasticsearch/plugins/'+name) do
        it { should be_directory }
        it { should be_owned_by 'root' }
      end
      it 'should be installed and the right version' do
        plugins = curl_json("#{es_api_url}/_nodes/plugins", username=username, password=password)
        version = nil
        _node, data = plugins['nodes'].first
        data['plugins'].each do |p|
          version = p['version'] if p['name'] == name
        end
        expect(version).to eql(vars['es_version'])
      end
    end
  end
  describe file("/etc/elasticsearch/elasticsearch.yml") do
    it { should be_owned_by 'root' }
    it { should contain "node.name: localhost" }
    it { should contain 'cluster.name: elasticsearch' }
    it { should_not contain "path.conf: /etc/elasticsearch" }
    its(:content) { should match "path.data: #{vars['es_data_dirs'].join(',')}" }
    its(:content) { should match "path.logs: /var/log/elasticsearch" }
  end

  if vars['es_use_repository']
    if vars['ansible_os_family'] == 'RedHat'
      describe file("/etc/yum.repos.d/elasticsearch-#{vars['es_repo_name']}.repo") do
        it { should exist }
      end
      describe yumrepo("elasticsearch-#{vars['es_repo_name']}") do
        it { should exist }
        it { should be_enabled }
      end
      describe file("/etc/yum.repos.d/elasticsearch-#{vars['es_other_repo_name']}.repo") do
        it { should_not exist }
      end
      describe yumrepo("elasticsearch-#{vars['es_other_repo_name']}") do
        it { should_not exist }
        it { should_not be_enabled }
      end
    end
    if vars['ansible_os_family'] == 'Debian'
      describe command('apt-cache policy') do
        its(:stdout) { should match /elastic.co.*\/#{Regexp.quote(vars['es_repo_name'])}\//}
        its(:stdout) { should_not match /elastic.co.*\/#{Regexp.quote(vars['es_other_repo_name'])}\//}
      end
    end
  end
end
