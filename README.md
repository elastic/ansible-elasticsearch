# ansible-elasticsearch

Ansible playbook / roles / tasks for Elasticsearch.  Currently it will work on Debian and RedHat based linux systems.

## Usage

Create your Ansible playbook with your own tasks, and include the role elasticsearch.  You will have to have this repository accessible within the context of playbook, e.g.

e.g. 

```
cd /my/repos/
git clone git@github.com:elastic/ansible-elasticsearch.git
cd /my/ansible/playbook
mkdir -p roles
ln -s /my/repos/ansible-elasticsearch ./roles/elasticsearch
```

Then create your playbook yaml adding the role elasticsearch.  By default, the user is only required to specify a unique es_instance_name per role application.  

The simplest configuration therefore consists of: 

```
---
- name: Simple Example
  hosts: localhost
  roles:
    - { role: elasticsearch, es_instance_name: "node1" }
  vars:
```

All Elasticsearch configuration parameters are supported.  This is achieved using a configuration map parameter 'es_config' which is serialized into the elasticsearch.yml file.  
The use of a map ensures the Ansible playbook does not need to be updated to reflect new/deprecated/plugin configuration parameters.

In addition to the es_config map, several other parameters are supported for additional functions e.g. script installation.  These can be found in the role's defaults/main.yml file.

The following illustrates applying configuration parameters to an Elasticsearch instance.

```
- name: Elasticsearch with custom configuration
  hosts: localhost
  roles:
    #expand to all available parameters
    - { role: elasticsearch, es_instance_name: "node1", es_data_dir: "/opt/elasticsearch/data", es_log_dir: "/opt/elasticsearch/logs", es_work_dir: "/opt/elasticsearch/temp", es_config: {node.name: "node1", cluster.name: "custom-cluster", discovery.zen.ping.unicast.hosts: "localhost:9301", http.port: 9201, transport.tcp.port: 9301, node.data: false, node.master: true, bootstrap.mlockall: true, discovery.zen.ping.multicast.enabled: false } }
  vars:
    es_scripts: false
    es_templates: false
    es_version_lock: false
    es_heap_size: 1g
```



The playbook utilises Elasticsearch version defaults.  By default, therefore, multicast is enabled for 1.x. If disabled, the user user is required to specify the following additional parameters:

1. es_config['http.port'] - the http port for the node
2. es_config['transport.tcp.port'] - the transport port for the node
3. es_config['discovery.zen.ping.unicast.hosts'] - the unicast discovery list, in the comma separated format "<host>:<port>,<host>:<port>" (typically the clusters dedicated masters)


If set to true, the ports will be auto defined and node discovery will be performed using multicast.

A more complex example:

```
---
- name: Elasticsearch with custom configuration
  hosts: localhost
  roles:
    #expand to all available parameters
    - { role: elasticsearch, es_instance_name: "node1", es_data_dir: "/opt/elasticsearch/data", es_log_dir: "/opt/elasticsearch/logs", es_work_dir: "/opt/elasticsearch/temp", es_config: {node.name: "node1", cluster.name: "custom-cluster", discovery.zen.ping.unicast.hosts: "localhost:9301", http.port: 9201, transport.tcp.port: 9301, node.data: false, node.master: true, bootstrap.mlockall: true, discovery.zen.ping.multicast.enabled: false } }
  vars:
    es_scripts: false
    es_templates: false
    es_version_lock: false
    es_heap_size: 1g
    es_scripts: false
    es_templates: false
    es_version_lock: false
    es_start_service: false
    es_plugins_reinstall: false
    es_plugins:
        - plugin: elasticsearch/elasticsearch-cloud-aws
          version: 2.5.0
        - plugin: elasticsearch/marvel
          version: latest
        - plugin: elasticsearch/license
          version: latest
        - plugin: elasticsearch/shield
          version: latest
        - plugin: elasticsearch/elasticsearch-support-diagnostics
          version: latest
        - plugin: lmenezes/elasticsearch-kopf
          version: master
```

The application of a role results in the installation of a node on a host. Multiple roles equates to multiple nodes for a single host. 

In any multi node cluster configuration it is recommened the user list the master eligble roles first - especially if these are used a unicast hosts off which other nodes are 'booted'

An example of a two server deployment, each with 1 node on one server and 2 nodes on another.  The first server holds the master and is thus declared first.

```
---

- hosts: master_nodes
  roles:
    # one master per host
    - { role: elasticsearch, es_instance_name: "node1", es_heap_size: "1g", es_config: { "discovery.zen.ping.multicast.enabled": false, discovery.zen.ping.unicast.hosts: "elastic02:9300", http.port: 9200, transport.tcp.port: 9300, node.data: false, node.master: true, bootstrap.mlockall: false, discovery.zen.ping.multicast.enabled: false } }
  vars:
    es_scripts: false
    es_templates: false
    es_version_lock: false
    es_cluster_name: test-cluster
    ansible_user: ansible
    es_plugins:
     - plugin: elasticsearch/license
       version: latest

- hosts: data_nodes
  roles:
    # two nodes per host
    - { role: elasticsearch, es_instance_name: "node1", es_data_dir: "/opt/elasticsearch", es_config: { "discovery.zen.ping.multicast.enabled": false, discovery.zen.ping.unicast.hosts: "elastic02:9300", http.port: 9200, transport.tcp.port: 9300, node.data: true, node.master: false, bootstrap.mlockall: false, discovery.zen.ping.multicast.enabled: false } }
    - { role: elasticsearch, es_instance_name: "node2", es_config: { "discovery.zen.ping.multicast.enabled": false, discovery.zen.ping.unicast.hosts: "elastic02:9300", http.port: 9201, transport.tcp.port: 9301, node.data: true, node.master: false, bootstrap.mlockall: false, discovery.zen.ping.multicast.enabled: false } }
  vars:
    es_scripts: false
    es_templates: false
    es_version_lock: false
    es_cluster_name: test-cluster
    ansible_user: ansible
    es_plugins:
     - plugin: elasticsearch/license
       version: latest
```

Parameters can additionally be assigned to hosts using the inventory file if desired.

Make sure your hosts are defined in your ```inventory``` file with the appropriate ```ansible_ssh_host```,  ```ansible_ssh_user``` and ```ansible_ssh_private_key_file``` values.

Then run it:

```
ansible-playbook -i hosts ./your-playbook.yml
```

## Configuration
You can add the role without any customisation and it will by default install Java and Elasticsearch, without any plugins.

Following variables affect the versions installed:

* ```es_major_version``` (e.g. "1.5" )
* ```es_version``` (e.g. "1.5.2")
* ```es_start_service``` (true (default) or false)
* ```es_plugins_reinstall``` (true or false (default) )
* ```es_plugins``` (an array of plugin definitons e.g.:

```
    es_plugins:
      - plugin: elasticsearch-cloud-aws
        version: 2.5.0
 ```

* ```java_repos``` (an array of repositories to be added to allow java to be installed)
* ```java_packages``` (an array of packages to be installed to get Java installed)
