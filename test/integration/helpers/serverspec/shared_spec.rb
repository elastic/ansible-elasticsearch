require 'spec_helper'
require 'json'
vars = JSON.parse(File.read('/tmp/vars.json'))

shared_examples 'shared::init' do |vars|
  describe user(vars['es_user']) do
    it { should exist }
    it { should belong_to_group vars['es_group'] }
    it { should have_login_shell '/bin/false' }
    it { should have_uid vars['es_user_id'] } if vars.key?('es_user_id')

    its(:encrypted_password) { should eq('*') }
  end

  describe package(vars['es_package_name']) do
    it { should be_installed }
  end

  describe service('node1_elasticsearch') do
    it { should be_running }
  end

  describe port(vars['es_api_port']) do
    it { should be_listening.with('tcp') }
  end

 # if vars['es_templates']
 #   describe file('/etc/elasticsearch/templates') do
 #     it { should be_directory }
 #     it { should be_owned_by vars['es_user'] }
 #   end
 #   describe file('/etc/elasticsearch/templates/basic.json') do
 #     it { should be_file }
 #     it { should be_owned_by vars['es_user'] }
 #   end
 #   describe 'Template Installed' do
 #     it 'should be reported as being installed', :retry => 3, :retry_wait => 10 do
 #       command = command('curl localhost:9200/_template/basic')
 #       expect(command.stdout).to match(/basic/)
 #       expect(command.exit_status).to eq(0)
 #     end
 #   end
 #   describe 'Template Installed' do
 #     it 'should be reported as being installed', :retry => 3, :retry_wait => 10 do
 #       command = command('curl localhost:9201/_template/basic')
 #       expect(command.stdout).to match(/basic/)
 #       expect(command.exit_status).to eq(0)
 #     end
 #   end
 # end
  if vars['es_scripts']
    describe file('/etc/elasticsearch/node1/scripts') do
      it { should be_directory }
      it { should be_owned_by 'elasticsearch' }
    end
    describe file('/etc/elasticsearch/node1/scripts/calculate-score.groovy') do
      it { should be_file }
      it { should be_owned_by 'elasticsearch' }
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

  describe file('/etc/elasticsearch/elasticsearch.yml') do
    it { should_not exist }
  end

  describe file('/etc/elasticsearch/logging.yml') do
    it { should_not exist }
  end

  vars['es_plugins'].each do |plugin|
    name = plugin['plugin']
    url = "http://localhost:#{vars['es_api_port']}"

    describe file('/usr/share/elasticsearch/plugins/'+name) do
      it { should be_directory }
      it { should be_owned_by vars['es_user'] }
    end
    it 'should be installed and the right version' do
      plugins = curl_json("#{url}/_nodes/plugins")
      version = nil
      _node, data = plugins['nodes'].first
      data['plugins'].each do |p|
        version = p['version'] if p['name'] == name
      end
      expect(version).to eql(vars['es_version'])
    end
  end
end
