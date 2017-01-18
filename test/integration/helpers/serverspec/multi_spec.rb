require 'spec_helper'

shared_examples 'multi::init' do  |es_version,plugins|

  describe user('elasticsearch') do
    it { should exist }
  end

  describe service('node1_elasticsearch') do
    it { should be_running }
  end

  describe service('master_elasticsearch') do
    it { should be_running }
  end

  describe package('elasticsearch') do
    it { should be_installed }
  end

  #test configuration parameters have been set - test all appropriately set in config file
  describe file('/etc/elasticsearch/node1/elasticsearch.yml') do
    it { should be_file }
    it { should contain 'http.port: 9201' }
    it { should contain 'transport.tcp.port: 9301' }
    it { should contain 'node.data: true' }
    it { should contain 'node.master: false' }
    it { should contain 'node.name: localhost-node1' }
    it { should_not contain 'bootstrap.memory_lock: true' }
    it { should contain 'path.conf: /etc/elasticsearch/node1' }
    it { should contain 'path.data: /opt/elasticsearch/data-1/localhost-node1,/opt/elasticsearch/data-2/localhost-node1' }
    it { should contain 'path.logs: /var/log/elasticsearch/localhost-node1' }
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
    it { should contain 'path.conf: /etc/elasticsearch/master' }
    it { should contain 'path.data: /opt/elasticsearch/master/localhost-master' }
    it { should contain 'path.logs: /var/log/elasticsearch/localhost-master' }
  end

  describe 'Master listening' do
    it 'listening in port 9200' do
      expect(port 9200).to be_listening
    end
  end

  describe 'Node listening' do
    it 'node should be listening in port 9201' do
      expect(port 9201).to be_listening
    end
  end

  #test we started on the correct port was used for master
  describe 'master started' do
    it 'master node should be running', :retry => 3, :retry_wait => 10 do
      command = command('curl "localhost:9200" | grep name')
      #expect(command.stdout).should match '/*master_localhost*/'
      expect(command.exit_status).to eq(0)
    end
  end

  #test we started on the correct port was used for node 1
  describe 'node1 started' do
    it 'node should be running', :retry => 3, :retry_wait => 10 do
      command = command('curl "localhost:9201" | grep name')
      #expect(command.stdout).should match '/*node1_localhost*/'
      expect(command.exit_status).to eq(0)
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
      command = command('curl localhost:9200/_template/basic')
      expect(command.stdout).to match(/basic/)
      expect(command.exit_status).to eq(0)
    end
  end

  describe 'Template Installed' do
    it 'should be reported as being installed', :retry => 3, :retry_wait => 10 do
      command = command('curl localhost:9201/_template/basic')
      expect(command.stdout).to match(/basic/)
      expect(command.exit_status).to eq(0)
    end
  end

  #Confirm scripts are on both nodes
  describe file('/etc/elasticsearch/node1/scripts') do
    it { should be_directory }
    it { should be_owned_by 'elasticsearch' }
  end

  describe file('/etc/elasticsearch/node1/scripts/calculate-score.groovy') do
    it { should be_file }
    it { should be_owned_by 'elasticsearch' }
  end

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

  describe file('/opt/elasticsearch/data-1/localhost-node1') do
    it { should be_directory }
    it { should be_owned_by 'elasticsearch' }
  end


  describe file('/opt/elasticsearch/data-2/localhost-node1') do
    it { should be_directory }
    it { should be_owned_by 'elasticsearch' }
  end

  #test to make sure mlock was applied
  describe command('curl -s "localhost:9200/_nodes/localhost-master/process?pretty=true" | grep mlockall') do
    its(:stdout) { should match /true/ }
    its(:exit_status) { should eq 0 }
  end

  #test to make sure mlock was not applied
  describe command('curl -s "localhost:9201/_nodes/localhost-node1/process?pretty=true" | grep mlockall') do
    its(:stdout) { should match /false/ }
    its(:exit_status) { should eq 0 }
  end

  describe 'version check on master' do
    it 'should be reported as version '+es_version do
      command = command('curl -s localhost:9200 | grep number')
      expect(command.stdout).to match(es_version)
      expect(command.exit_status).to eq(0)
    end
  end

  describe 'version check on data' do
    it 'should be reported as version '+es_version do
      command = command('curl -s localhost:9201 | grep number')
      expect(command.stdout).to match(es_version)
      expect(command.exit_status).to eq(0)
    end
  end

  for plugin in plugins

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


  #Test server spec file has been created and modified - currently not possible as not copied for debian 8
  #describe file('/usr/lib/systemd/system/master_elasticsearch.service') do
  #  it { should be_file }
  #  it { should contain 'LimitMEMLOCK=infinity' }
  #end

  #describe file('/usr/lib/systemd/system/node1_elasticsearch.service') do
  #  it { should be_file }
  #  it { should_not contain 'LimitMEMLOCK=infinity' }
  #end

end

