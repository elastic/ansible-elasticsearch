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

end

