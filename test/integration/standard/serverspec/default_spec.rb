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

  describe command('curl localhost:9200/_nodes/?plugin | grep kopf') do
    its(:stdout) { should match /kopf/ }
    its(:exit_status) { should eq 0 }
  end

end

