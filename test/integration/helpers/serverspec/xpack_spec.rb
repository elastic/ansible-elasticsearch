require 'spec_helper'

shared_examples 'xpack::init' do |vars|
  describe file("/etc/elasticsearch/elasticsearch.yml") do
    it { should contain "node.name: localhost" }
    it { should contain 'cluster.name: elasticsearch' }
    it { should_not contain "path.conf: /etc/elasticsearch" }
    it { should contain "path.data: /var/lib/elasticsearch" }
    it { should contain "path.logs: /var/log/elasticsearch" }
    it { should contain 'xpack.security.enabled: false' }
    it { should contain 'xpack.watcher.enabled: false' }
  end
end
