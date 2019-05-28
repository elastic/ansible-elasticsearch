require 'shared_spec'
require 'json'
vars = JSON.parse(File.read('/tmp/vars.json'))

describe 'Xpack upgrade Tests' do
  include_examples 'shared::init', vars
end
