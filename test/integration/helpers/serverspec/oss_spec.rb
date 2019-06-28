require 'spec_helper'

shared_examples 'oss::init' do |vars|
  describe file("/etc/elasticsearch/log4j2.properties") do
    it { should be_file }
    it { should be_owned_by 'elasticsearch' }
    it { should_not contain 'CUSTOM LOG4J FILE' }
  end
  describe file("/etc/elasticsearch/jvm.options") do
    it { should be_file }
    it { should be_owned_by vars['es_user'] }
  end
end
