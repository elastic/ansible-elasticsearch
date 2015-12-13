require 'package_spec'

describe 'Package Tests v 1.x' do
  include_examples 'package::init', "1.7.3", ["kopf","marvel"]
end