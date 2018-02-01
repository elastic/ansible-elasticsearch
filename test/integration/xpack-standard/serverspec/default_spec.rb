require 'xpack_standard_spec'
require 'json'
vars = JSON.parse(File.read('/tmp/vars.json'))

describe 'Xpack Standard Tests' do
  include_examples 'xpack_standard::init', vars
end
