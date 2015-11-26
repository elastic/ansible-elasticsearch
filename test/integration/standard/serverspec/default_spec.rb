require 'spec_helper'

context "basic tests" do

  describe user('elasticsearch') do
    it { should exist }
  end

  describe service('node1_elasticsearch') do
    it { should be_running }
  end

  describe package('elasticsearch') do
    it { should be_installed }
  end

  describe file('/etc/elasticsearch/node1/elasticsearch.yml') do
    it { should be_file }
    it { should be_owned_by 'elasticsearch' }
  end

  describe file('/etc/elasticsearch/node1/logging.yml') do
    it { should be_file }
    it { should be_owned_by 'elasticsearch' }
  end

  describe file('/etc/elasticsearch/node1/elasticsearch.yml') do
    it { should contain 'node.name: localhost-node1' }
    it { should contain 'cluster.name: elasticsearch' }
    it { should contain 'path.conf: /etc/elasticsearch/node1' }
    it { should contain 'path.data: /var/lib/elasticsearch/localhost-node1' }
    it { should contain 'path.work: /tmp/elasticsearch/localhost-node1' }
    it { should contain 'path.logs: /var/log/elasticsearch/localhost-node1' }
  end

  describe 'Node listening' do
    it 'listening in port 9200' do
      expect(port 9200).to be_listening
    end
  end

  describe 'plugin' do
    it 'should be reported as existing', :retry => 3, :retry_wait => 10 do
      command = command('curl localhost:9200/_nodes/?plugin | grep kopf')
      expect(command.stdout).to match(/kopf/)
      expect(command.exit_status).to eq(0)
    end
  end

end

