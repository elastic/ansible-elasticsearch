require 'package_spec'
require 'json'
vars = JSON.parse(File.read('/tmp/vars.json'))

describe 'Package Tests' do
  include_examples 'package::init', vars
end
