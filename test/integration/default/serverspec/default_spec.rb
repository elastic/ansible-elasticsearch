require 'shared_spec'
require 'json'
vars = JSON.parse(File.read('/tmp/vars.json'))

describe 'default tests' do
  include_examples 'shared::init', vars
end
