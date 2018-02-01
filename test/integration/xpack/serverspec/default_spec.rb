require 'xpack_spec'
require 'json'
vars = JSON.parse(File.read('/tmp/vars.json'))

describe 'Xpack Tests' do
  include_examples 'xpack::init', vars
end
