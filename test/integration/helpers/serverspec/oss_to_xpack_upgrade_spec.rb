require 'spec_helper'

shared_examples 'oss_to_xpack_upgrade::init' do |vars|
  describe 'version check' do
    it 'should be reported as version '+vars['es_version'] do
      expect(curl_json('http://localhost:9200', username='elastic', password='changeme')['version']['number']).to eq(vars['es_version'])
    end
    it 'should be be running the standard (xpack) version' do
      expect(curl_json('http://localhost:9200/_xpack', username='elastic', password='changeme')['tagline']).to eq('You know, for X')
    end
  end
end
