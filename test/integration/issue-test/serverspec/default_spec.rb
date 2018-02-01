require 'issue_test_spec'
require 'json'
vars = JSON.parse(File.read('/tmp/vars.json'))

describe 'Issue Test' do
  include_examples 'issue_test::init', vars
end

