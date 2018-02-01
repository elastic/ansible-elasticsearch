require 'config_spec'
require 'json'
vars = JSON.parse(File.read('/tmp/vars.json'))

describe 'Config Tests' do
  include_examples 'config::init', vars
end

