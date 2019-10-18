require 'serverspec'
require 'net/http'
require 'json'

set :backend, :exec

require 'rspec/retry'

RSpec.configure do |config|
  # show retry status in spec process
  config.verbose_retry = true
  # show exception that triggers a retry if verbose_retry is set to true
  config.display_try_failure_messages = true
end

def curl_json(uri, username=nil, password=nil)
  uri = URI(uri)
  req =  Net::HTTP::Get.new(uri)
  if username && password
    req.basic_auth username, password
  end
  res = Net::HTTP.start(
    uri.hostname,
    uri.port,
    :use_ssl => uri.scheme == 'https',
    :verify_mode => OpenSSL::SSL::VERIFY_NONE
  ) {|http|
    http.request(req)
  }
  return JSON.parse(res.body)
end
