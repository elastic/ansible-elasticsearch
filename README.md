# ansible-elasticsearch
[![Build Status](https://img.shields.io/jenkins/s/https/devops-ci.elastic.co/job/elastic+ansible-elasticsearch+master.svg)](https://devops-ci.elastic.co/job/elastic+ansible-elasticsearch+master/)
[![Ansible Galaxy](https://img.shields.io/badge/ansible--galaxy-elastic.elasticsearch-blue.svg)](https://galaxy.ansible.com/elastic/elasticsearch/)

**THIS ROLE IS FOR 6.x, 5.x. FOR 2.x SUPPORT PLEASE USE THE 2.x BRANCH.**

Ansible role for 6.x/5.x Elasticsearch.  Currently this works on Debian and RedHat based linux systems. Tested platforms are:

* Ubuntu 14.04
* Ubuntu 16.04
* Debian 8
* CentOS 7

The latest Elasticsearch versions of 6.x and 5.x are actively tested.  **Only Ansible versions > 2.4.3.0 are supported, as this is currently the only version tested.**

##### Dependency
This role uses the json_query filter which [requires jmespath](https://github.com/ansible/ansible/issues/24319) on the local machine.

## Usage

Create your Ansible playbook with your own tasks, and include the role elasticsearch. You will have to have this repository accessible within the context of playbook.

```sh
ansible-galaxy install elastic.elasticsearch
```

Then create your playbook yaml adding the role elasticsearch. By default, the user is only required to specify a unique es_instance_name per role application.  This should be unique per node. 
The application of the elasticsearch role results in the installation of a node on a host.

The simplest configuration therefore consists of: 

```yaml
- name: Simple Example
  hosts: localhost
  roles:
    - role: elastic.elasticsearch
      es_instance_name: "node1"
```

The above installs a single node 'node1' on the hosts 'localhost'.

This role also uses [Ansible tags](http://docs.ansible.com/ansible/playbooks_tags.html). Run your playbook with the `--list-tasks` flag for more information.

## Testing

This playbook uses [Kitchen](https://kitchen.ci/) for CI and local testing.

### Requirements

* Ruby
* Bundler
* Docker
* Make

### Running the tests

If you want to test X-Pack features with a license you will first need to export the `ES_XPACK_LICENSE_FILE` variable.
```sh
export ES_XPACK_LICENSE_FILE="$(pwd)/license.json"
```

To converge an Ubuntu 16.04 host running X-Pack
```sh
$ make converge
```

To run the tests
```sh
$ make verify
```

To list all of the different test suits
```sh
$ make list
```

The default test suite is Ubuntu 16.04 with X-Pack. If you want to test another suite you can override this with the `PATTERN` variable
```sh
$ make converge PATTERN=oss-centos-7
```

The `PATTERN` is a kitchen pattern which can match multiple suites. To run all tests for CentOS
```sh
$ make converge PATTERN=centos-7
```

The default version is 6.x If you want to test 5.x you can override it with the `VERSION` variable to test 5.x
```sh
$ make converge VERSION=5.x PATTERN=oss-centos-7
```

When you are finished testing you can clean up everything with
```sh
$ make destroy-all
```

### Basic Elasticsearch Configuration

All Elasticsearch configuration parameters are supported.  This is achieved using a configuration map parameter 'es_config' which is serialized into the elasticsearch.yml file.  
The use of a map ensures the Ansible playbook does not need to be updated to reflect new/deprecated/plugin configuration parameters.

In addition to the es_config map, several other parameters are supported for additional functions e.g. script installation.  These can be found in the role's defaults/main.yml file.

The following illustrates applying configuration parameters to an Elasticsearch instance.

```yaml
- name: Elasticsearch with custom configuration
  hosts: localhost
  roles:
    - role: elastic.elasticsearch
  vars:
    es_instance_name: "node1"
    es_data_dirs:
      - "/opt/elasticsearch/data"
    es_log_dir: "/opt/elasticsearch/logs"
    es_config:
      node.name: "node1"
      cluster.name: "custom-cluster"
      discovery.zen.ping.unicast.hosts: "localhost:9301"
      http.port: 9201
      transport.tcp.port: 9301
      node.data: false
      node.master: true
      bootstrap.memory_lock: true
    es_scripts: false
    es_templates: false
    es_version_lock: false
    es_heap_size: 1g
    es_api_port: 9201
```

Whilst the role installs Elasticsearch with the default configuration parameters, the following should be configured to ensure a cluster successfully forms:

* ```es_config['http.port']``` - the http port for the node
* ```es_config['transport.tcp.port']``` - the transport port for the node
* ```es_config['discovery.zen.ping.unicast.hosts']``` - the unicast discovery list, in the comma separated format ```"<host>:<port>,<host>:<port>"``` (typically the clusters dedicated masters)
* ```es_config['network.host']``` - sets both network.bind_host and network.publish_host to the same host value. The network.bind_host setting allows to control the host different network components will bind on.  

The network.publish_host setting allows to control the host the node will publish itself within the cluster so other nodes will be able to connect to it. 

See https://www.elastic.co/guide/en/elasticsearch/reference/current/modules-network.html for further details on default binding behaviour and available options.
The role makes no attempt to enforce the setting of these are requires users to specify them appropriately.  IT is recommended master nodes are listed and thus deployed first where possible.

A more complex example:

```yaml
- name: Elasticsearch with custom configuration
  hosts: localhost
  roles:
    - role: elastic.elasticsearch
  vars:
    es_instance_name: "node1"
    es_data_dirs:
      - "/opt/elasticsearch/data"
    es_log_dir: "/opt/elasticsearch/logs"
    es_config:
      node.name: "node1"
      cluster.name: "custom-cluster"
      discovery.zen.ping.unicast.hosts: "localhost:9301"
      http.port: 9201
      transport.tcp.port: 9301
      node.data: false
      node.master: true
      bootstrap.memory_lock: true
    es_scripts: false
    es_templates: false
    es_version_lock: false
    es_heap_size: 1g
    es_start_service: false
    es_plugins_reinstall: false
    es_api_port: 9201
    es_plugins:
      - plugin: ingest-geoip
        proxy_host: proxy.example.com
        proxy_port: 8080
```

#### Important Note

**The role uses es_api_host and es_api_port to communicate with the node for actions only achievable via http e.g. to install templates and to check the NODE IS ACTIVE.  These default to "localhost" and 9200 respectively.  
If the node is deployed to bind on either a different host or port, these must be changed.**

### Multi Node Server Installations

The application of the elasticsearch role results in the installation of a node on a host. Specifying the role multiple times for a host therefore results in the installation of multiple nodes for the host. 

An example of a two server deployment is shown below.  The first server holds the master and is thus declared first.  Whilst not mandatory, this is recommended in any multi node cluster configuration.  The second server hosts two data nodes.

**Note the structure of the below playbook for the data nodes.  Whilst a more succinct structures are possible which allow the same role to be applied to a host multiple times, we have found the below structure to be the most reliable with respect to var behaviour.  This is the tested approach.**

```yaml
- hosts: master_nodes
  roles:
    - role: elastic.elasticsearch
  vars:
    es_instance_name: "node1"
    es_heap_size: "1g"
    es_config:
      cluster.name: "test-cluster"
      discovery.zen.ping.unicast.hosts: "elastic02:9300"
      http.port: 9200
      transport.tcp.port: 9300
      node.data: false
      node.master: true
      bootstrap.memory_lock: false
    es_scripts: false
    es_templates: false
    es_version_lock: false
    ansible_user: ansible
    es_plugins:
     - plugin: ingest-geoip

- hosts: data_nodes
  roles:
    - role: elastic.elasticsearch
  vars:
    es_instance_name: "node1"
    es_data_dirs: 
      - "/opt/elasticsearch"
    es_config:
      discovery.zen.ping.unicast.hosts: "elastic02:9300"
      http.port: 9200
      transport.tcp.port: 9300
      node.data: true
      node.master: false
      bootstrap.memory_lock: false
      cluster.name: "test-cluster"
    es_scripts: false
    es_templates: false
    es_version_lock: false
    ansible_user: ansible
    es_api_port: 9200
    es_plugins:
      - plugin: ingest-geoip
    
- hosts: data_nodes
  roles:
    - role: elastic.elasticsearch
  vars:
    es_instance_name: "node2"
    es_api_port: 9201
    es_config:
      discovery.zen.ping.unicast.hosts: "elastic02:9300"
      http.port: 9201
      transport.tcp.port: 9301
      node.data: true
      node.master: false
      bootstrap.memory_lock: false
      cluster.name: "test-cluster"
    es_scripts: false
    es_templates: false
    es_version_lock: false
    es_api_port: 9201
    ansible_user: ansible
    es_plugins:
      - plugin: ingest-geoip
```

Parameters can additionally be assigned to hosts using the inventory file if desired.

Make sure your hosts are defined in your ```inventory``` file with the appropriate ```ansible_ssh_host```,  ```ansible_ssh_user``` and ```ansible_ssh_private_key_file``` values.

Then run it:

```sh
ansible-playbook -i hosts ./your-playbook.yml
```

### Installing X-Pack Features

X-Pack features, such as Security, are supported. This feature is currently experimental.

The parameter `es_xpack_features` by default enables all features i.e. it defaults to ["alerting","monitoring","graph","security","ml"]

The following additional parameters allow X-Pack to be configured:

* ```es_message_auth_file``` System Key field to allow message authentication. This file should be placed in the 'files' directory.
* ```es_xpack_custom_url``` Url from which X-Pack can be downloaded. This can be used for installations in isolated environments where the elastic.co repo is not accessible. e.g. ```es_xpack_custom_url: "https://artifacts.elastic.co/downloads/packs/x-pack/x-pack-5.5.1.zip"```
* ```es_role_mapping``` Role mappings file declared as yml as described [here](https://www.elastic.co/guide/en/x-pack/current/mapping-roles.html)


```yaml
es_role_mapping:
  power_user:
    - "cn=admins,dc=example,dc=com"
  user:
    - "cn=users,dc=example,dc=com"
    - "cn=admins,dc=example,dc=com"
```

* ```es_users``` - Users can be declared here as yml. Two sub keys 'native' and 'file' determine the realm under which realm the user is created.  Beneath each of these keys users should be declared as yml entries. e.g.

```yaml
es_users:
  native:
    kibana4_server:
      password: changeMe
      roles:
        - kibana4_server
  file:
    es_admin:
      password: changeMe
      roles:
        - admin
    testUser:
      password: changeMeAlso!
      roles:
        - power_user
        - user
```
            
            
* ```es_roles``` - Elasticsearch roles can be declared here as yml. Two sub keys 'native' and 'file' determine how the role is created i.e. either through a file or http(native) call.  Beneath each key list the roles with appropriate permissions, using the file based format described [here] (https://www.elastic.co/guide/en/x-pack/current/file-realm.html) e.g.

```yaml
es_roles:
  file:
    admin:
      cluster:
        - all
      indices:
        - names: '*'
          privileges:
            - all
    power_user:
      cluster:
        - monitor
      indices:
        - names: '*'
          privileges:
            - all
    user:
      indices:
        - names: '*'
          privileges:
            - read
    kibana4_server:
      cluster:
          - monitor
      indices:
        - names: '.kibana'
          privileges:
            - all
  native:
    logstash:
      cluster:
        - manage_index_templates
      indices:
        - names: 'logstash-*'
          privileges:
            - write
            - delete
            - create_index
```                
                
* ```es_xpack_license``` - X-Pack license. The license is a json blob. Set the variable directly (possibly protected by Ansible vault) or from a file in the Ansible project on the control machine via a lookup:

```yaml
es_xpack_license: "{{ lookup('file', playbook_dir + '/files/' + es_cluster_name + '/license.json') }}"
``` 

X-Pack configuration parameters can be added to the elasticsearch.yml file using the normal `es_config` parameter.

For a full example see [here](https://github.com/elastic/ansible-elasticsearch/blob/master/test/integration/xpack-upgrade.yml)

#### Important Note for Native Realm Configuration

In order for native users and roles to be configured, the role calls the Elasticsearch API.  Given security is installed this requires definition of two parameters:

* ```es_api_basic_auth_username``` - admin username
* ```es_api_basic_auth_password``` - admin password

These can either be set to a user declared in the file based realm, with admin permissions, or the default "elastic" superuser (default password is changeme).


### Additional Configuration

In addition to es_config, the following parameters allow the customization of the Java and Elasticsearch versions as well as the role behaviour. Options include:

* ```es_enable_xpack```  Default `true`. Setting this to `false` will install the oss release of elasticsearch
* ```es_major_version```  Should be consistent with es_version. For versions >= 5.0 and < 6.0 this must be "5.x". For versions >= 6.0 this must be "6.x".
* ```es_version``` (e.g. "6.3.0").
* ```es_api_host``` The host name used for actions requiring HTTP e.g. installing templates. Defaults to "localhost".
* ```es_api_port``` The port used for actions requiring HTTP e.g. installing templates. Defaults to 9200. **CHANGE IF THE HTTP PORT IS NOT 9200**
* ```es_api_basic_auth_username``` The Elasticsearch username for making admin changing actions. Used if Security is enabled. Ensure this user is admin.
* ```es_api_basic_auth_password``` The password associated with the user declared in `es_api_basic_auth_username`
* ```es_start_service``` (true (default) or false)
* ```es_plugins_reinstall``` (true or false (default) )
* ```es_plugins``` an array of plugin definitions e.g.:
  ```yaml
    es_plugins:
      - plugin: ingest-geoip 
  ```
* ```es_path_repo``` Sets the whitelist for allowing local back-up repositories
* ```es_action_auto_create_index ``` Sets the value for auto index creation, use the syntax below for specifying indexes (else true/false):
     es_action_auto_create_index: '[".watches", ".triggered_watches", ".watcher-history-*"]'
* ```es_allow_downgrades``` For development purposes only. (true or false (default) )
* ```es_java_install``` If set to false, Java will not be installed. (true (default) or false)
* ```update_java``` Updates Java to the latest version. (true or false (default))
* ```es_max_map_count``` maximum number of VMA (Virtual Memory Areas) a process can own. Defaults to 262144.
* ```es_max_open_files``` the maximum file descriptor number that can be opened by this process. Defaults to 65536.
* ```es_max_threads``` the maximum number of threads the process can start. Defaults to 2048 (the minimum required by elasticsearch).
* ```es_debian_startup_timeout``` how long Debian-family SysV init scripts wait for the service to start, in seconds. Defaults to 10 seconds.

Earlier examples illustrate the installation of plugins using `es_plugins`.  For officially supported plugins no version or source delimiter is required. The plugin script will determine the appropriate plugin version based on the target Elasticsearch version.  For community based plugins include the full url.  This approach should NOT be used for the X-Pack plugin.  See X-Pack below for details here.
 
If installing Monitoring or Alerting, ensure the license plugin is also specified.  Security configuration currently has limited support, but more support is planned for later versions.

To configure X-pack to send mail, the following configuration can be added to the role. When require_auth is true, you will also need to provide the user and password. If not these can be removed:
```yaml
    es_mail_config:
        account: <functional name>
        profile: standard
        from: <from address>
        require_auth: <true or false>
        host: <mail domain>
        port: <port number>
        user: <e-mail address> --optional
        pass: <password> --optional
```

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
* ```es_restart_on_change``` - defaults to true.  If false, changes will not result in Elasticsearch being restarted.
* ```es_plugins_reinstall``` - defaults to false.  If true, all currently installed plugins will be removed from a node.  Listed plugins will then be re-installed.  

This role ships with sample scripts and templates located in the [files/scripts/](files/scripts) and [files/templates/](files/templates) directories, respectively. These variables are used with the Ansible [with_fileglob](http://docs.ansible.com/ansible/playbooks_loops.html#id4) loop. When setting the globs, be sure to use an absolute path.
* ```es_scripts_fileglob``` - defaults to `<role>/files/scripts/`.
* ```es_templates_fileglob``` - defaults to `<role>/files/templates/`.

### Proxy

To define proxy globally, set the following variables:

* ```es_proxy_host``` - global proxy host
* ```es_proxy_port``` - global proxy port

To define proxy only for a particular plugin during its installation:

```yaml
  es_plugins:
    - plugin: ingest-geoip 
      proxy_host: proxy.example.com
      proxy_port: 8080
```

> For plugins installation, proxy_host and proxy_port are used first if they are defined and fallback to the global proxy settings if not. The same values are currently used for both the http and https proxy settings.

## Notes

* The role assumes the user/group exists on the server.  The elasticsearch packages create the default elasticsearch user.  If this needs to be changed, ensure the user exists.
* The playbook relies on the inventory_name of each host to ensure its directories are unique
* Changing an instance_name for a role application will result in the installation of a new component.  The previous component will remain.
* KitchenCI has been used for testing.  This is used to confirm images reach the correct state after a play is first applied.  We currently test the latest version of 6.x and 5.x on all supported platforms. 
* The role aims to be idempotent.  Running the role multiple times, with no changes, should result in no state change on the server.  If the configuration is changed, these will be applied and Elasticsearch restarted where required.
* Systemd is used for Ubuntu versions >= 15, Debian >=8, Centos >=7.  All other versions use init for service scripts.
* In order to run x-pack tests a license file with security enabled is required. A trial license is appropriate. Set the environment variable `ES_XPACK_LICENSE_FILE` to the full path of the license file prior to running tests.

## IMPORTANT NOTES RE PLUGIN MANAGEMENT

* If the ES version is changed, all plugins will be removed.  Those listed in the playbook will be re-installed.  This is behaviour is required in ES 6.x.
* If no plugins are listed in the playbook for a node, all currently installed plugins will be removed.
* The role supports automatic detection of differences between installed and listed plugins - installing those listed but not installed, and removing those installed but not listed.   Should users wish to re-install plugins they should set es_plugins_reinstall to true.  This will cause all currently installed plugins to be removed and those listed to be installed.

## Questions on Usage

We welcome questions on how to use the role.  However, in order to keep the GitHub issues list focused on "issues" we ask the community to raise questions at https://discuss.elastic.co/c/elasticsearch.  This is monitored by the maintainers.