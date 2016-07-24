require 'package_spec'


describe 'Package Tests v 2.x' do
  include_examples 'package::init', "2.3.4", ["kopf"]
end