# ansible-elasticsearch

Ansible playbook / roles / tasks for Elasticsearch.  Currently it will work on Debian and RedHat based linux systems.

## Usage

Create your ansible playbook with your own tasks, and include the role elasticsearch.
You will have to have this repository accessible within the context of playbook, e.g.

e.g. 

```
cd /my/repos/
git clone git@github.com:elastic/ansible-elasticsearch.git
cd /my/ansible/playbook
mkdir -p roles
ln -s /my/repos/ansible-elasticsearch ./roles/elasticsearch
```

Then create your playbook yaml adding the role elasticsearch and overriding any variables you wish.  It can be as simple as this to take all the defaults:


```
---
hosts: my_host
  roles:
    - { role: elasticsearch, es_multicast_enabled: true}
  tasks:
    - .... your tasks ...
```

By default es_multicast_enabled is false and the user is required to specify the following additional parameters:

1. es_http_port - the http port for the node
2. es_transport_tcp_port - the transport port for the node
3. es_unicast_hosts - the unicast discovery list, in the comma separated format "<host>:<port>,<host>:<port>" (typically the clusters dedicated masters)


If set to true, the ports will be auto defined and node discovery will be performed using multicast.

A more complex example:

```
---
hosts: localhost
roles:
  - { role: elasticsearch, es_unicast_hosts: "localhost:9301", es_http_port: "9201", es_transport_tcp_port: "9301", es_data_node: false, es_master_node: true, es_m_lock_enabled: true, es_multicast_enabled: false, es_node_name_prefix: "node1_", es_cluster_name: "custom-cluster" }
vars:
  es_scripts: false
  es_templates: false
  es_version_lock: false
  es_m_lock_enabled: true
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
tasks:
  - .... your tasks ...
```

The above example illustrates the ability to control the configuration.  

The application of a role results in the installation of a node on a host. Multiple roles equates to multiple nodes for a single host.  If specifying multiple roles for a host, and thus multiple nodes, the user must:

1. Provide a es_node_name_prefix.  This is used to ensure seperation of data, log, config and init scripts.
2. Ensure those playbooks responsible for installing and starting master eligble roles are specified first. These are required for cluster initalization.

An example of a two server deployment, each with 1 node on one server and 2 nodes on another.  The first server holds the master and is thus declared first.

```
---
hosts: masters
roles:
  - { role: elasticsearch, es_node_name_prefix: "node1_", es_unicast_hosts: "localhost:9300", es_http_port: "9201", es_transport_tcp_port: "9301", es_data_node: true, es_master_node: false, es_m_lock_enabled: true, es_multicast_enabled: false }
vars:
  es_scripts: false
  es_templates: false
  es_version_lock: false
  es_cluster_name: example-cluster
  m_lock_enabled: false

- hosts: data_nodes
  roles:
    - { role: elasticsearch, es_data_node: true, es_master_node: false, es_m_lock_enabled: true, es_multicast_enabled: false, es_node_name_prefix: "node1_" }
    - { role: elasticsearch, es_data_node: true, es_master_node: false, es_m_lock_enabled: true, es_multicast_enabled: false, es_node_name_prefix: "node2_" }
  vars:
    es_scripts: false
    es_templates: false
    es_version_lock: false
    es_cluster_name: example-cluster
    m_lock_enabled: true
    es_plugins:
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
