require 'package_spec'


describe 'Package Tests v 2.x' do
  include_examples 'package::init', "2.4.3", ["kopf"]
end