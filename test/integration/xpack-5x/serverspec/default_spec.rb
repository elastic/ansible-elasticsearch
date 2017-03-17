require 'xpack_spec'

describe 'Xpack Tests v 5.x' do
  include_examples 'xpack::init', "5.2.2", ["ingest-attachment"]
end
