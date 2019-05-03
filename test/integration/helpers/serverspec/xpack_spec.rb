require 'spec_helper'

shared_examples 'xpack::init' do |vars|
  describe file("/etc/elasticsearch/#{vars['es_instance_name']}/elasticsearch.yml") do
    it { should contain "node.name: localhost-#{vars['es_instance_name']}" }
    it { should contain 'cluster.name: elasticsearch' }
    it { should_not contain "path.conf: /etc/elasticsearch/#{vars['es_instance_name']}" }
    it { should contain "path.data: /var/lib/elasticsearch/localhost-#{vars['es_instance_name']}" }
    it { should contain "path.logs: /var/log/elasticsearch/localhost-#{vars['es_instance_name']}" }
    it { should contain 'xpack.security.enabled: false' }
    it { should contain 'xpack.watcher.enabled: false' }
  end
end
