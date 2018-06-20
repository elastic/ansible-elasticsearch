require 'oss_upgrade_spec'
require 'shared_spec'
require 'json'
vars = JSON.parse(File.read('/tmp/vars.json'))

describe 'oss upgrade Tests' do
  include_examples 'oss_upgrade::init', vars
  include_examples 'shared::init', vars
end
