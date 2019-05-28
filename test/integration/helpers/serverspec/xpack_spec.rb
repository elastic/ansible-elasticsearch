require 'spec_helper'

shared_examples 'xpack::init' do |vars|
  describe file("/etc/elasticsearch/#{vars['es_instance_name']}/elasticsearch.yml") do
    it { should contain "node.name: localhost-#{vars['es_instance_name']}" }
    it { should contain 'cluster.name: elasticsearch' }
    it { should_not contain "path.conf: /etc/elasticsearch/#{vars['es_instance_name']}" }
    it { should contain "path.data: /var/lib/elasticsearch/localhost-#{vars['es_instance_name']}" }
    it { should contain "path.logs: /var/log/elasticsearch/localhost-#{vars['es_instance_name']}" }
    if vars.key?('es_xpack_features')
      it { should contain 'xpack.security.enabled: true' } if vars['es_xpack_features'].include? 'security'
      it { should contain 'xpack.watcher.enabled: true' } if vars['es_xpack_features'].include? 'alerting'
    end
  end
end
