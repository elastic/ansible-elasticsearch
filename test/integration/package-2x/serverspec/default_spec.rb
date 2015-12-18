require 'package_spec'


describe 'Package Tests v 2.x' do
  include_examples 'package::init', "2.1.0", ["kopf","license","marvel-agent"]
end