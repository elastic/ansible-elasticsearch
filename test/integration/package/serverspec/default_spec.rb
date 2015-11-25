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
  end

  describe file('/etc/elasticsearch/node1/scripts') do
    it { should be_directory }
    it { should be_owned_by 'elasticsearch' }
  end

  describe 'Node listening' do
    it 'listening in port 9200' do
      expect(port 9200).to be_listening
    end
  end

end

