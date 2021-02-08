require 'spec_helper'
require 'shared_spec'

shared_examples 'custom_config::init' do |vars|
  describe file("/etc/elasticsearch/log4j2.properties") do
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should contain 'Log4j CUSTOM FILE' }
  end
  describe file("/etc/elasticsearch/jvm.options") do
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should contain 'JVM configuration CUSTOM FILE' }
  end
  describe file($family['defaults_path']) do
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should contain 'Elasticsearch CUSTOM FILE' }
  end
end
