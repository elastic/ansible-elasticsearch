require 'spec_helper'
require 'json'
require 'pathname'
vars = JSON.parse(File.read('/tmp/vars.json'))

es_api_url = "#{vars['es_api_scheme']}://localhost:#{vars['es_api_port']}"
username = vars['es_api_basic_auth_username']
password = vars['es_api_basic_auth_password']
es_keystore = Pathname.new(vars['es_ssl_keystore']).basename.to_s
es_truststore = Pathname.new(vars['es_ssl_truststore']).basename.to_s

if vars['es_major_version'] == '7.x'
  es_license_api = "_license"
else
  es_license_api = "_xpack/license"
end

shared_examples 'license::init' do |vars|
  describe 'License check' do
    result = curl_json("#{es_api_url}/#{es_license_api}", username=username, password=password)
    it 'should list the license issued by Elastic' do
      expect(result['license']['status']).to eq('active')
      expect(result['license']['type']).to eq('trial')
      expect(result['license']['issued_to']).to eq('Elastic - INTERNAL (non-production environments)')
    end
  end
end
