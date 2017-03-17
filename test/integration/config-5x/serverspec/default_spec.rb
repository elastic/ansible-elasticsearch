require 'config_spec'

describe 'Config Tests v 5.x' do
  include_examples 'config::init', "5.2.2", ["ingest-attachment","ingest-user-agent"]
end

