require 'spec_helper'
require 'json'
vars = JSON.parse(File.read('/tmp/vars.json'))

shared_examples 'multi::init' do |vars|

  describe service('master_elasticsearch') do
    it { should be_running }
  end
  #test configuration parameters have been set - test all appropriately set in config file
  describe file("/etc/elasticsearch/#{vars['es_instance_name']}/elasticsearch.yml") do
    it { should be_file }
    it { should contain 'http.port: 9201' }
    it { should contain 'transport.tcp.port: 9301' }
    it { should contain 'node.data: true' }
    it { should contain 'node.master: false' }
    it { should contain "node.name: localhost-#{vars['es_instance_name']}" }
    it { should_not contain 'bootstrap.memory_lock: true' }
    if vars['es_major_version'] == '6.x'
      it { should_not contain "path.conf: /etc/elasticsearch/#{vars['es_instance_name']}" }
    else
      it { should contain "path.conf: /etc/elasticsearch/#{vars['es_instance_name']}" }
    end
    it { should contain "path.data: /opt/elasticsearch/data-1/localhost-#{vars['es_instance_name']},/opt/elasticsearch/data-2/localhost-#{vars['es_instance_name']}" }
    it { should contain "path.logs: /var/log/elasticsearch/localhost-#{vars['es_instance_name']}" }
  end


  #test configuration parameters have been set for master - test all appropriately set in config file
  describe file('/etc/elasticsearch/master/elasticsearch.yml') do
    it { should be_file }
    it { should contain 'http.port: 9200' }
    it { should contain 'transport.tcp.port: 9300' }
    it { should contain 'node.data: false' }
    it { should contain 'node.master: true' }
    it { should contain 'node.name: localhost-master' }
    it { should contain 'bootstrap.memory_lock: true' }
    if vars['es_major_version'] == '6.x'
      it { should_not contain 'path.conf: /etc/elasticsearch/master' }
    else
      it { should contain 'path.conf: /etc/elasticsearch/master' }
    end
    it { should contain 'path.data: /opt/elasticsearch/master/localhost-master' }
    it { should contain 'path.logs: /var/log/elasticsearch/localhost-master' }
  end

  describe 'Master listening' do
    it 'listening in port 9200' do
      expect(port 9200).to be_listening
    end
  end

  #test we started on the correct port was used for master
  describe 'master started' do
    it 'master node should be running', :retry => 3, :retry_wait => 10 do
      expect(curl_json('http://localhost:9200')['name']).to eq('localhost-master')
    end
  end

  #test we started on the correct port was used for node 1
  describe "#{vars['es_instance_name']} started" do
    it 'node should be running', :retry => 3, :retry_wait => 10 do
      expect(curl_json('http://localhost:9201')['name']).to eq("localhost-#{vars['es_instance_name']}")
    end
  end

  #Confirm scripts are on both nodes
  describe file('/etc/elasticsearch/master/scripts') do
    it { should be_directory }
    it { should be_owned_by 'elasticsearch' }
  end

  describe file('/etc/elasticsearch/master/scripts/calculate-score.groovy') do
    it { should be_file }
    it { should be_owned_by 'elasticsearch' }
  end

  #Confirm that the data directory has only been set for the first node
  describe file('/opt/elasticsearch/master/localhost-master') do
    it { should be_directory }
    it { should be_owned_by 'elasticsearch' }
  end

  describe file("/opt/elasticsearch/data-1/localhost-#{vars['es_instance_name']}") do
    it { should be_directory }
    it { should be_owned_by 'elasticsearch' }
  end


  describe file("/opt/elasticsearch/data-2/localhost-#{vars['es_instance_name']}") do
    it { should be_directory }
    it { should be_owned_by 'elasticsearch' }
  end

  #test to make sure mlock was applied
  describe command('curl -s "localhost:9200/_nodes/localhost-master/process?pretty=true" | grep mlockall') do
    its(:stdout) { should match /true/ }
    its(:exit_status) { should eq 0 }
  end

  #test to make sure mlock was not applied
  describe command("curl -s 'localhost:9201/_nodes/localhost-#{vars['es_instance_name']}/process?pretty=true' | grep mlockall") do
    its(:stdout) { should match /false/ }
    its(:exit_status) { should eq 0 }
  end

  describe 'version check on master' do
    it 'should be reported as version '+vars['es_version'] do
      command = command('curl -s localhost:9200 | grep number')
      expect(command.stdout).to match(vars['es_version'])
      expect(command.exit_status).to eq(0)
    end
  end

  describe 'version check on data' do
    it 'should be reported as version '+vars['es_version'] do
      command = command('curl -s localhost:9201 | grep number')
      expect(command.stdout).to match(vars['es_version'])
      expect(command.exit_status).to eq(0)
    end
  end

  for plugin in vars['es_plugins']
    plugin = plugin['plugin']

    describe command('curl -s localhost:9200/_nodes/plugins?pretty=true | grep '+plugin) do
      its(:exit_status) { should eq 0 }
    end

    describe command('curl -s localhost:9201/_nodes/plugins?pretty=true | grep '+plugin) do
      its(:exit_status) { should eq 0 }
    end

    describe file('/usr/share/elasticsearch/plugins/'+plugin) do
      it { should be_directory }
      it { should be_owned_by 'elasticsearch' }
    end
  end
end
