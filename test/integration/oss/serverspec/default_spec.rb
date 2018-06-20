require 'oss_spec'
require 'shared_spec'
require 'json'
vars = JSON.parse(File.read('/tmp/vars.json'))

describe 'OSS Tests' do
  include_examples 'oss::init', vars
  include_examples 'shared::init', vars
end



