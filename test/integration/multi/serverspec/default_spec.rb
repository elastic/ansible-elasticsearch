require 'multi_spec'
require 'shared_spec'
require 'json'
vars = JSON.parse(File.read('/tmp/vars.json'))

describe 'Shared Tests' do
  include_examples 'shared::init', vars
end

describe 'Multi Tests' do
  include_examples 'multi::init', vars
end