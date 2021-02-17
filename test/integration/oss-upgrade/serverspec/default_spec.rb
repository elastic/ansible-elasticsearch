require 'shared_spec'
require 'json'
vars = JSON.parse(File.read('/tmp/vars.json'))

describe 'oss upgrade tests' do
  include_examples 'shared::init', vars
end
