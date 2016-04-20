# ansible-elasticsearch

Ansible role for Elasticsearch.  Currently this works on Debian and RedHat based linux systems.  Tested platforms are:

* Ubuntu 14.04
* Debian 7
* Debian 8
* Centos 6
* Centos 7

The latest Elasticsearch versions of 1.7.x and 2.x are actively tested.  **Only Ansible versions 2.x are supported.**

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

Then create your playbook yaml adding the role elasticsearch.  By default, the user is only required to specify a unique es_instance_name per role application.  This should be unique per node. 
The application of the elasticsearch role results in the installation of a node on a host.

The simplest configuration therefore consists of: 

```
---
- name: Simple Example
  hosts: localhost
  roles:
    - { role: elasticsearch, es_instance_name: "node1" }
  vars:
```

The above installs a single node 'node1' on the hosts 'localhost'.

### Basic Elasticsearch Configuration

All Elasticsearch configuration parameters are supported.  This is achieved using a configuration map parameter 'es_config' which is serialized into the elasticsearch.yml file.  
The use of a map ensures the Ansible playbook does not need to be updated to reflect new/deprecated/plugin configuration parameters.

In addition to the es_config map, several other parameters are supported for additional functions e.g. script installation.  These can be found in the role's defaults/main.yml file.

The following illustrates applying configuration parameters to an Elasticsearch instance.  By default, Elasticsearch 2.1.0 is installed.

```
- name: Elasticsearch with custom configuration
  hosts: localhost
  roles:
    #expand to all available parameters
    - { role: elasticsearch, es_instance_name: "node1", es_data_dirs: "/opt/elasticsearch/data", es_log_dir: "/opt/elasticsearch/logs", es_work_dir: "/opt/elasticsearch/temp", 
    es_config: {
        node.name: "node1", 
        cluster.name: "custom-cluster",
        discovery.zen.ping.unicast.hosts: "localhost:9301",
        http.port: 9201,
        transport.tcp.port: 9301,
        node.data: false,
        node.master: true,
        bootstrap.mlockall: true,
        discovery.zen.ping.multicast.enabled: false } 
    }
  vars:
    es_scripts: false
    es_templates: false
    es_version_lock: false
    es_heap_size: 1g
```
`
The role utilises Elasticsearch version defaults.  Multicast is therefore enabled for 1.x and disabled for 2.x (plugin required in 2.x).  If using 1.x it is strongly recommended you disable
multicast and specify the required uni-cast settings for a production environment. 
When not utilizing multicast, the following should be set to ensure a successful cluster forms.

* ```es_config['http.port']``` - the http port for the node
* ```es_config['transport.tcp.port']``` - the transport port for the node
* ```es_config['discovery.zen.ping.unicast.hosts']``` - the unicast discovery list, in the comma separated format ```"<host>:<port>,<host>:<port>"``` (typically the clusters dedicated masters)
* ```es_config['network.host']``` - sets both network.bind_host and network.publish_host to the same host value. The network.bind_host setting allows to control the host different network components will bind on.  

The network.publish_host setting allows to control the host the node will publish itself within the cluster so other nodes will be able to connect to it. 

See https://www.elastic.co/guide/en/elasticsearch/reference/current/modules-network.html for further details on default binding behaviour and available options.
The role makes no attempt to enforce the setting of these are requires users to specify them appropriately.  IT is recommended master nodes are listed and thus deployed first where possible.

A more complex example:

```
---
- name: Elasticsearch with custom configuration
  hosts: localhost
  roles:
    #expand to all available parameters
    - { role: elasticsearch, es_instance_name: "node1", es_data_dirs: "/opt/elasticsearch/data", es_log_dir: "/opt/elasticsearch/logs", es_work_dir: "/opt/elasticsearch/temp", 
    es_config: {
        node.name: "node1", 
        cluster.name: "custom-cluster", 
        discovery.zen.ping.unicast.hosts: "localhost:9301", 
        http.port: 9201, 
        transport.tcp.port: 9301, 
        node.data: false, 
        node.master: true, 
        bootstrap.mlockall: true, 
        discovery.zen.ping.multicast.enabled: false } 
    }
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
        - plugin: license
        - plugin: marvel-agent
        - plugin: lmenezes/elasticsearch-kopf
          version: master
          proxy_host: proxy.example.com
          proxy_port: 8080
```

### Multi Node Server Installations

The application of the elasticsearch role results in the installation of a node on a host. Specifying the role multiple times for a host therefore results in the installation of multiple nodes for the host. 

An example of a two server deployment, each with 1 node on one server and 2 nodes on another.  The first server holds the master and is thus declared first.  Whilst not mandatory, this is 
recommended in any multi node cluster configuration.


```
- hosts: master_nodes
  roles:
    - { role: elasticsearch, es_instance_name: "node1", es_heap_size: "1g",
    es_config: {
        cluster.name: "test-cluster",
        "discovery.zen.ping.multicast.enabled": false,
        discovery.zen.ping.unicast.hosts: "elastic02:9300",
        http.port: 9200,
        transport.tcp.port: 9300,
        node.data: false,
        node.master: true,
        bootstrap.mlockall: false,
        discovery.zen.ping.multicast.enabled: false }
    }
  vars:
    es_scripts: false
    es_templates: false
    es_version_lock: false
    ansible_user: ansible
    es_plugins:
     - plugin: elasticsearch/license
       version: latest

- hosts: data_nodes
  roles:
    - { role: elasticsearch, es_instance_name: "node1", es_data_dirs: "/opt/elasticsearch", 
    es_config: {
        "discovery.zen.ping.multicast.enabled": false,
        discovery.zen.ping.unicast.hosts: "elastic02:9300",
        http.port: 9200,
        transport.tcp.port: 9300,
        node.data: true,
        node.master: false,
        bootstrap.mlockall: false,
        cluster.name: "test-cluster",
        discovery.zen.ping.multicast.enabled: false } 
    }
    - { role: elasticsearch, es_instance_name: "node2", 
    es_config: {
        "discovery.zen.ping.multicast.enabled": false,
        discovery.zen.ping.unicast.hosts: "elastic02:9300",
        http.port: 9201,
        transport.tcp.port: 9301,
        node.data: true,
        node.master: false,
        bootstrap.mlockall: false,
        cluster.name: "test-cluster",
        discovery.zen.ping.multicast.enabled: false } 
    }
  vars:
    es_scripts: false
    es_templates: false
    es_version_lock: false
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

### Additional Configuration

Additional parameters to es_config allow the customization of the Java and Elasticsearch versions, in addition to role behaviour. Options include:

Following variables affect the versions installed:

* ```es_major_version``` (e.g. "1.5" ). Should be consistent with es_version. For versions >= 2.0 this must be "2.x".
* ```es_version``` (e.g. "1.5.2").  
* ```es_start_service``` (true (default) or false)
* ```es_plugins_reinstall``` (true or false (default) )
* ```es_plugins``` (an array of plugin definitions e.g.:

```
  es_plugins:
    - plugin: elasticsearch-cloud-aws
      version: 2.5.0
```

Earlier examples illustrate the installation of plugins for 2.x.  The correct use of this parameter varies depending on the version of Elasticsearch being installed:
 
 - 2.x. - For officially supported plugins no version or source delimiter is required. The plugin script will determine the appropriate plugin version based on the target Elasticsearch version.  
 For community based plugins include the full path e.g. "lmenezes/elasticsearch-kopf" and the appropriate version for the target version of Elasticsearch.
 - 1.x - Full path and version is required for both community and official plugins e.g. "elasticsearch/marvel"
 
If installing Marvel or Watcher, ensure the license plugin is also specified.  Shield configuration is currently not supported but planned for later versions.

* ```es_user``` - defaults to elasticsearch.
* ```es_group``` - defaults to elasticsearch.
* ```es_user_id``` - default is undefined.
* ```es_group_id``` - default is undefined.

Both ```es_user_id``` and ```es_group_id``` must be set for the user and group ids to be set. 

By default, each node on a host will be installed to use unique pid, plugin, work, data and log directories.  These directories are created, using the instance and host name, beneath default locations ]
controlled by the following parameters:

* ```es_pid_dir``` - defaults to "/var/run/elasticsearch".
* ```es_data_dirs``` - defaults to "/var/lib/elasticsearch".  This can be a list or comma separated string e.g. ["/opt/elasticsearch/data-1","/opt/elasticsearch/data-2"] or "/opt/elasticsearch/data-1,/opt/elasticsearch/data-2"
* ```es_log_dir``` - defaults to "/var/log/elasticsearch".
* ```es_work_dir``` - defaults to "/tmp/elasticsearch".
* ```es_plugin_dir``` - defaults to "/usr/share/elasticsearch/plugins".
* ```es_restart_on_change``` - defaults to true.  If false, changes will not result in Elasticsearch being restarted.
* ```es_plugins_reinstall``` - defaults to false.  If true, all currently installed plugins will be removed from a node.  Listed plugins will then be re-installed.  

This role ships with sample scripts and templates located in the [files/scripts/](files/scripts) and [files/templates/](files/templates) directories, respectively. These variables are used with the Ansible [with_fileglob](http://docs.ansible.com/ansible/playbooks_loops.html#id4) loop. When setting the globs, be sure to use an absolute path.
* ```es_scripts_fileglob``` - defaults to `<role>/files/scripts/`.
* ```es_templates_fileglob``` - defaults to `<role>/files/templates/`.

### Proxy

To define proxy globaly, set the following variables:

* ```es_proxy_host``` - global proxy host
* ```es_proxy_port``` - global proxy port

To define proxy only for a particular plugin during its installation:

```
  es_plugins:
    - plugin: elasticsearch-cloud-aws
      version: 2.5.0
      proxy_host: proxy.example.com
      proxy_port: 8080
```

> For plugins installation, proxy_host and proxy_port are used first if they are defined and fallback to the global proxy settings if not.

## Notes

* The role assumes the user/group exists on the server.  The elasticsearch packages create the default elasticsearch user.  If this needs to be changed, ensure the user exists.
* The playbook relies on the inventory_name of each host to ensure its directories are unique
* Changing an instance_name for a role application will result in the installation of a new component.  The previous component will remain.
* KitchenCI has been used for testing.  This is used to confirm images reach the correct state after a play is first applied.  We currently test only the latest version of each major release i.e. 1.7.3 and 2.1.0 on
all supported platforms. 
* The role aims to be idempotent.  Running the role multiple times, with no changes, should result in no state change on the server.  If the configuration is changed, these will be applied and 
Elasticsearch restarted where required.
* Systemd is used for Ubuntu versions >= 15, Debian >=8, Centos >=7.  All other versions use init for service scripts.

## IMPORTANT NOTES RE PLUGIN MANAGEMENT

* If the ES version is changed, all plugins will be removed.  Those listed in the playbook will be re-installed.  This is behaviour is required in ES 2.x.
* If no plugins are listed in the playbook for a node, all currently installed plugins will be removed.
* The role does not currently support automatic detection of differences between installed and listed plugins (other than if none are listed).   Should users wish to change installed plugins should set es_plugins_reinstall to true.  This will cause all currently installed plugins to be removed and those listed to be installed.  Change detection will be implemented in future releases.
