require 'multi_spec'


describe 'Multi Tests v 2.x' do
  include_examples 'multi::init', "2.2.0", ["kopf","license","marvel-agent"]
end


