require 'multi_spec'


describe 'Multi Tests v 1.x' do
  include_examples 'multi::init', "1.7.3", ["kopf","marvel"]
end