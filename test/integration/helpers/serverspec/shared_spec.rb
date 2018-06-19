require 'spec_helper'
require 'json'
vars = JSON.parse(File.read('/tmp/vars.json'))

families = {
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

family = families[vars['ansible_os_family']]

es_api_url = "http://localhost:#{vars['es_api_port']}"
username = vars['es_api_basic_auth_username']
password = vars['es_api_basic_auth_password']

shared_examples 'shared::init' do |vars|
  describe 'version check' do
    it 'should be reported as version '+vars['es_version'] do
      expect(curl_json(es_api_url, username=username, password=password)['version']['number']).to eq(vars['es_version'])
    end
  end
  describe 'xpack checks' do
    if vars['es_enable_xpack']
      it 'should be be running the xpack version' do
        expect(curl_json("#{es_api_url}/_xpack", username=username, password=password)['tagline']).to eq('You know, for X')
      end
      it 'xpack should be activated' do
        expect(curl_json("#{es_api_url}/_license", username=username, password=password)['license']['status']).to eq('active')
      end
      features = curl_json("#{es_api_url}/_xpack", username=username, password=password)
      curl_json("#{es_api_url}/_xpack", username=username, password=password)['features'].each do |feature,values|
        enabled = vars['es_xpack_features'].include? feature
		status = if enabled then 'enabled' else 'disabled' end
		it "the xpack feature '#{feature}' to be #{status}" do
          expect(values['enabled'] = enabled)
        end
      end
      # X-Pack is no longer installed as a plugin in elasticsearch
      if vars['es_major_version'] == '5.x'
        describe file('/usr/share/elasticsearch/plugins/x-pack') do
          it { should be_directory }
          it { should be_owned_by vars['es_user'] }
        end
        describe file("/etc/elasticsearch/#{vars['es_instance_name']}/x-pack") do
          it { should be_directory }
          it { should be_owned_by vars['es_user'] }
        end
        describe 'x-pack-core plugin' do
          it 'should be installed with the correct version' do
            plugins = curl_json("#{es_api_url}/_nodes/plugins", username=username, password=password)
            node, data = plugins['nodes'].first
            version = 'plugin not found'
            name = 'x-pack'

            data['plugins'].each do |plugin|
              if plugin['name'] == name
                version = plugin['version']
              end
            end
            expect(version).to eql(vars['es_version'])
          end
        end
      end
    end
  end
  describe user(vars['es_user']) do
    it { should exist }
    it { should belong_to_group vars['es_group'] }
    it { should have_uid vars['es_user_id'] } if vars.key?('es_user_id')

    it { should have_login_shell family['shell'] }

    its(:encrypted_password) { should eq(family['password']) }
  end

  describe package(vars['es_package_name']) do
    it { should be_installed }
  end

  describe service("#{vars['es_instance_name']}_elasticsearch") do
    it { should be_running }
  end

  describe port(vars['es_api_port']) do
    it { should be_listening.with('tcp') }
  end

  if vars['es_templates']
    describe file('/etc/elasticsearch/templates') do
      it { should be_directory }
      it { should be_owned_by vars['es_user'] }
    end
    describe file('/etc/elasticsearch/templates/basic.json') do
      it { should be_file }
      it { should be_owned_by vars['es_user'] }
    end
    #This is possibly subject to format changes in the response across versions so may fail in the future
    describe 'Template Contents Correct' do
      it 'should be reported as being installed', :retry => 3, :retry_wait => 10 do
        template = curl_json("#{es_api_url}/_template/basic", username=username, password=password)
        expect(template.key?('basic'))
        expect(template['basic']['settings']['index']['number_of_shards']).to eq("1")
        expect(template['basic']['mappings']['type1']['_source']['enabled']).to eq(false)
      end
    end
  end
  if vars['es_scripts']
    describe file("/etc/elasticsearch/#{vars['es_instance_name']}/scripts") do
      it { should be_directory }
      it { should be_owned_by 'elasticsearch' }
    end
    describe file("/etc/elasticsearch/#{vars['es_instance_name']}/scripts/calculate-score.groovy") do
      it { should be_file }
      it { should be_owned_by 'elasticsearch' }
    end
  end
  describe file('/etc/init.d/elasticsearch') do
    it { should_not exist }
  end

  describe file(family['defaults_path']) do
    its(:content) { should match '' }
  end

  describe file('/etc/elasticsearch/elasticsearch.yml') do
    it { should_not exist }
  end

  describe file('/etc/elasticsearch/logging.yml') do
    it { should_not exist }
  end

  if vars.key?('es_plugins')
    vars['es_plugins'].each do |plugin|
      name = plugin['plugin']
      describe file('/usr/share/elasticsearch/plugins/'+name) do
        it { should be_directory }
        it { should be_owned_by vars['es_user'] }
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
  describe file("/etc/elasticsearch/#{vars['es_instance_name']}/elasticsearch.yml") do
    it { should contain "node.name: localhost-#{vars['es_instance_name']}" }
    it { should contain 'cluster.name: elasticsearch' }
    if vars['es_major_version'] == '6.x'
      it { should_not contain "path.conf: /etc/elasticsearch/#{vars['es_instance_name']}" }
    else
      it { should contain "path.conf: /etc/elasticsearch/#{vars['es_instance_name']}" }
    end
    its(:content) { should match "path.data: #{vars['data_dirs'].join(',')}" }
    its(:content) { should match "path.logs: /var/log/elasticsearch/localhost-#{vars['es_instance_name']}" }
  end
end
