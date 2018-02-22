require 'standard_spec'
require 'json'
vars = JSON.parse(File.read('/tmp/vars.json'))

describe 'Standard Tests' do
  include_examples 'standard::init', vars
end



