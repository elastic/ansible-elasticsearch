require 'security_spec'
require 'shared_spec'
require 'json'
vars = JSON.parse(File.read('/tmp/vars.json'))

describe 'security tests' do
  include_examples 'shared::init', vars
  include_examples 'security::init', vars
end
