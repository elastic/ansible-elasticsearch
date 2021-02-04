require 'custom_config_spec'
require 'shared_spec'
require 'json'
vars = JSON.parse(File.read('/tmp/vars.json'))

describe 'Custom Config Tests' do
  include_examples 'custom_config::init', vars
  include_examples 'shared::init', vars
end
