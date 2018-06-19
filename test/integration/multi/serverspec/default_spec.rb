require 'multi_spec'
require 'shared_spec'
require 'json'
vars = JSON.parse(File.read('/tmp/vars.json'))

describe 'Multi Tests' do
  include_examples 'shared::init', vars
  include_examples 'multi::init', vars
end