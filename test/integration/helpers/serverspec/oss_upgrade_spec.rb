require 'spec_helper'

shared_examples 'oss_upgrade::init' do |vars|
  describe 'version check' do
    it 'should be reported as version '+vars['es_version'] do
      expect(curl_json('http://localhost:9200')['version']['number']).to eq(vars['es_version'])
    end
  end
end
