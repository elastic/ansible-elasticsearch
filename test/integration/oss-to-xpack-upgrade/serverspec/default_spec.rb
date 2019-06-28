require 'oss_to_xpack_upgrade_spec'
require 'shared_spec'
require 'json'
vars = JSON.parse(File.read('/tmp/vars.json'))

describe 'oss to xpack upgrade Tests' do
  include_examples 'shared::init', vars
  include_examples 'oss_to_xpack_upgrade::init', vars
end
