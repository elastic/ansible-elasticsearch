require 'spec_helper'

context "basic tests" do

  describe user('elasticsearch') do
    it { should exist }
  end

  describe service('elasticsearch') do
    it { should be_running }
  end

  describe package('elasticsearch') do
    it { should be_installed }
  end

  describe file('/etc/elasticsearch/elasticsearch.yml') do
    it { should be_file }
  end

  describe 'plugin' do

    it 'should be reported as existing', :retry => 3, :retry_wait => 10 do
      command = command('curl localhost:9200/_nodes/?plugin | grep kopf')
      expect(command.stdout).to match(/kopf/)
      expect(command.exit_status).to eq(0)
    end

  end

end

