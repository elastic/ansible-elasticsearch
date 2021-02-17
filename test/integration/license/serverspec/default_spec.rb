require 'license_spec'
require 'shared_spec'
require 'json'
vars = JSON.parse(File.read('/tmp/vars.json'))

describe 'license tests' do
  include_examples 'shared::init', vars
  include_examples 'license::init', vars
end
