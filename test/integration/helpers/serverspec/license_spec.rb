require 'spec_helper'

shared_examples 'license::init' do |vars|
  describe file("/var/log/elasticsearch/elasticsearch.log") do
    it { should be_file }
    it { should contain("mode [basic] - valid").after(/license/) }
    it { should contain 'Active license is now [BASIC]; Security is disabled' }
  end
end
