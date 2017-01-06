require 'package_spec'


describe 'Package Tests v 5.x' do
  include_examples 'package::init', "5.1.1", ["kopf"]
end