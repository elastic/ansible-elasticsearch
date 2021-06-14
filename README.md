# ansible-elasticsearch
[![Build Status](https://img.shields.io/jenkins/s/https/devops-ci.elastic.co/job/elastic+ansible-elasticsearch+master.svg)](https://devops-ci.elastic.co/job/elastic+ansible-elasticsearch+master/)
[![Ansible Galaxy](https://img.shields.io/badge/ansible--galaxy-elastic.elasticsearch-blue.svg)](https://galaxy.ansible.com/elastic/elasticsearch/)

**THIS ROLE IS FOR 7.x & 6.x**

Ansible role for 7.x/6.x Elasticsearch.  Currently this works on Debian and RedHat based linux systems. Tested platforms are:

* Ubuntu 14.04
* Ubuntu 16.04
* Ubuntu 18.04
* Ubuntu 20.04
* Debian 8
* Debian 9
* Debian 10
* CentOS 7
* CentOS 8
* Amazon Linux 2

The latest Elasticsearch versions of 7.x & 6.x are actively tested.

## BREAKING CHANGES

### Notice about multi-instance support

* If you use only one instance but want to upgrade from an older ansible-elasticsearch version, follow [upgrade procedure](https://github.com/elastic/ansible-elasticsearch/blob/master/docs/multi-instance.md#upgrade-procedure)
* If you install more than one instance of Elasticsearch on the same host (with different ports, directory and config files), **do not update to ansible-elasticsearch >= 7.1.1**, please follow this [workaround](https://github.com/elastic/ansible-elasticsearch/blob/master/docs/multi-instance.md#workaround) instead.
* For multi-instances use cases, we are now recommending Docker containers using our official images (https://www.elastic.co/guide/en/elasticsearch/reference/current/docker.html).

### Removing the MAX_THREAD settings

Ansible-elasticsearch 7.5.2 is removing the option to customize the maximum number of threads the process can start in [#637](https://github.com/elastic/ansible-elasticsearch/pull/637/files#diff-04c6e90faac2675aa89e2176d2eec7d8L408).
We discovered that this option wasn't working anymore since multi-instance support removal in ansible-elasticsearch 7.1.1.
This option will be added back in a following release if it's still relevant regarding latest Elasticsearch evolutions.

### Changes about configuration files

Ansible-elasticsearch 7.5.2 is updating the configuration files provided by this role in [#637](https://github.com/elastic/ansible-elasticsearch/pull/637) which contained some options deprecated in 6.x and 7.x:
- `/etc/default/elasticsearch`|`/etc/sysconfig/elasticsearch`: the new template reflect the configuration file provided by Elasticsearch >= 6.x, the parameters we removed were already not used in 6.x and 7.x
- `/etc/elasticsearch/jvm.options`: the new template reflect the configuration files provided by Elasticsearch >= 6.x
- `/etc/elasticsearch/log4j2.properties`:
  - We removed `log4j2.properties.j2` template from this Ansible role as it was a static file not bringing any customization specific to some ansible variable.
  - Deployment of this Ansible role on new servers will get the default `log4j2.properties` provided by Elasticsearch without any override.
  - **WARNING**: For upgrade scenarios where this file was already managed by previous versions of ansible-elasticsearch, this file will become unmanaged and won't be updated by default. If you wish to update it to 7.5 version, you can retrieve it [here](https://github.com/elastic/elasticsearch/blob/7.5/distribution/src/config/log4j2.properties) and use this file with `es_config_log4j2` Ansible variable (see below).

### Removing OSS distribution for versions >= 7.11.0

Starting from Elasticsearch 7.11.0, OSS distributions will no more provided following Elasticsearch
recent license change.

This Ansible role will fail if `oss_version` is set to `true` and `es_version` is greater than 
`7.11.0`.

See [Doubling down on open, Part II](https://www.elastic.co/blog/licensing-change for more details)
blog post for more details.

#### How to override configuration files provided by ansible-elasticsearch?

You can now override the configuration files with your own versions by using the following Ansible variables:
- `es_config_default: "elasticsearch.j2"`: replace `elasticsearch.j2` by your own template to use a custom `/etc/default/elasticsearch`|`/etc/sysconfig/elasticsearch` configuration file
- `es_config_jvm: "jvm.options.j2"`: replace `jvm.options.j2` by your own template to use a custom `/etc/elasticsearch/jvm.options` configuration file
- `es_config_log4j2: ""`: set this variable to the path of your own template to use a custom `/etc/elasticsearch/log4j2.properties` configuration file

## Dependency

This role uses the json_query filter which [requires jmespath](https://github.com/ansible/ansible/issues/24319) on the local machine.

## Usage

Create your Ansible playbook with your own tasks, and include the role elasticsearch. You will have to have this repository accessible within the context of playbook.

```sh
ansible-galaxy install elastic.elasticsearch,v7.13.2
```

Then create your playbook yaml adding the role elasticsearch.
The application of the elasticsearch role results in the installation of a node on a host.

The simplest configuration therefore consists of:

```yaml
- name: Simple Example
  hosts: localhost
  roles:
    - role: elastic.elasticsearch
  vars:
    es_version: 7.13.2
```

The above installs Elasticsearch 7.13.2 in a single node 'node1' on the hosts 'localhost'.

**Note**:
Elasticsearch default version is described in [`es_version`](https://github.com/elastic/ansible-elasticsearch/blob/master/defaults/main.yml#L2). You can override this variable in your playbook to install another version.
While we are testing this role only with one 7.x and one 6.x version (respectively [7.13.2](https://github.com/elastic/ansible-elasticsearch/blob/master/defaults/main.yml#L2) and [6.8.16](https://github.com/elastic/ansible-elasticsearch/blob/master/.kitchen.yml#L22) at the time of writing), this role should work with other versions also in most cases.

This role also uses [Ansible tags](http://docs.ansible.com/ansible/playbooks_tags.html). Run your playbook with the `--list-tasks` flag for more information.

## Testing

This playbook uses [Kitchen](https://kitchen.ci/) for CI and local testing.

### Requirements

* Ruby
* Bundler
* Docker
* Make

### Running the tests

* Ensure you have checked out this repository to `elasticsearch`, not `ansible-elasticsearch`.
* If you don't have a Gold or Platinum license to test with you can run the trial versions of the `xpack-upgrade` suites by appending `-trial` to the `PATTERN` variable.
* You may need to explicitly specify `VERSION=7.x` if some suites are failing.

Install the ruby dependencies with bundler

```sh
make setup
```

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
$ make converge PATTERN=security-centos-7
```

The `PATTERN` is a kitchen pattern which can match multiple suites. To run all tests for CentOS
```sh
$ make converge PATTERN=centos-7
```

The default version is 7.x. If you want to test 6.x you can override it with the `VERSION` variable, for example:
```sh
$ make converge VERSION=6.x PATTERN=security-centos-7
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
    es_data_dirs:
      - "/opt/elasticsearch/data"
    es_log_dir: "/opt/elasticsearch/logs"
    es_config:
      node.name: "node1"
      cluster.name: "custom-cluster"
      discovery.seed_hosts: "localhost:9301"
      http.port: 9201
      transport.port: 9301
      node.data: false
      node.master: true
      bootstrap.memory_lock: true
    es_heap_size: 1g
    es_api_port: 9201
```

Whilst the role installs Elasticsearch with the default configuration parameters, the following should be configured to ensure a cluster successfully forms:

* ```es_config['http.port']``` - the http port for the node
* ```es_config['transport.port']``` - the transport port for the node
* ```es_config['discovery.seed_hosts']``` - the unicast discovery list, in the comma separated format ```"<host>:<port>,<host>:<port>"``` (typically the clusters dedicated masters)
* ```es_config['cluster.initial_master_nodes']``` - for 7.x and above the list of master-eligible nodes to boostrap the cluster, in the comma separated format ```"<node.name>:<port>,<node.name>:<port>"``` (typically the node names of the clusters dedicated masters)
* ```es_config['network.host']``` - sets both network.bind_host and network.publish_host to the same host value. The network.bind_host setting allows to control the host different network components will bind on.

The `network.publish_host` setting allows to control the host the node will publish itself within the cluster so other nodes will be able to connect to it.

See https://www.elastic.co/guide/en/elasticsearch/reference/current/modules-network.html for further details on default binding behavior and available options.
The role makes no attempt to enforce the setting of these are requires users to specify them appropriately.  It is recommended master nodes are listed and thus deployed first where possible.

A more complex example:

```yaml
- name: Elasticsearch with custom configuration
  hosts: localhost
  roles:
    - role: elastic.elasticsearch
  vars:
    es_data_dirs:
      - "/opt/elasticsearch/data"
    es_log_dir: "/opt/elasticsearch/logs"
    es_config:
      node.name: "node1"
      cluster.name: "custom-cluster"
      discovery.seed_hosts: "localhost:9301"
      http.port: 9201
      transport.port: 9301
      node.data: false
      node.master: true
      bootstrap.memory_lock: true
    es_heap_size: 1g
    es_start_service: false
    es_api_port: 9201
    es_plugins:
      - plugin: ingest-attachment
```

#### Important Notes

**The role uses es_api_host and es_api_port to communicate with the node for actions only achievable via http e.g. to install templates and to check the NODE IS ACTIVE.  These default to "localhost" and 9200 respectively.
If the node is deployed to bind on either a different host or port, these must be changed.**

**Only use es_data_dirs and es_log_dir for customizing the data and log dirs respectively. When using together with `es_config['path.data']` and `es_config['path.logs']` it would result in generating duplicate data- and logs-keys in `elasticsearch.yml` and thus let fail to start elasticsearch.**

### Multi Node Server Installations

The application of the elasticsearch role results in the installation of a node on a host. Specifying the role multiple times for a host therefore results in the installation of multiple nodes for the host.

An example of a three server deployment is shown below.  The first server holds the master and is thus declared first.  Whilst not mandatory, this is recommended in any multi node cluster configuration.  The two others servers hosts data nodes.

**Note that we do not support anymore installation of more than one node in the same host**

```yaml
- hosts: master_node
  roles:
    - role: elastic.elasticsearch
  vars:
    es_heap_size: "1g"
    es_config:
      cluster.name: "test-cluster"
      cluster.initial_master_nodes: "elastic02"
      discovery.seed_hosts: "elastic02:9300"
      http.host: 0.0.0.0
      http.port: 9200
      node.data: false
      node.master: true
      transport.host: 0.0.0.0
      transport.port: 9300
      bootstrap.memory_lock: false
    es_plugins:
     - plugin: ingest-attachment

- hosts: data_node_1
  roles:
    - role: elastic.elasticsearch
  vars:
    es_data_dirs:
      - "/opt/elasticsearch"
    es_config:
      cluster.name: "test-cluster"
      cluster.initial_master_nodes: "elastic02"
      discovery.seed_hosts: "elastic02:9300"
      http.host: 0.0.0.0
      http.port: 9200
      node.data: true
      node.master: false
      transport.host: 0.0.0.0
      transport.port: 9300
      bootstrap.memory_lock: false
    es_plugins:
      - plugin: ingest-attachment

- hosts: data_node_2
  roles:
    - role: elastic.elasticsearch
  vars:
    es_config:
      cluster.name: "test-cluster"
      discovery.seed_hosts: "elastic02:9300"
      http.host: 0.0.0.0
      http.port: 9200
      node.data: true
      node.master: false
      transport.host: 0.0.0.0
      transport.port: 9300
      bootstrap.memory_lock: false
    es_plugins:
      - plugin: ingest-attachment
```

Parameters can additionally be assigned to hosts using the inventory file if desired.

Make sure your hosts are defined in your ```inventory``` file with the appropriate ```ansible_ssh_host```,  ```ansible_ssh_user``` and ```ansible_ssh_private_key_file``` values.

Then run it:

```sh
ansible-playbook -i hosts ./your-playbook.yml
```

### Installing X-Pack Features

* ```es_role_mapping``` Role mappings file declared as yml as described [here](https://www.elastic.co/guide/en/x-pack/current/mapping-roles.html)


```yaml
es_role_mapping:
  power_user:
    - "cn=admins,dc=example,dc=com"
  user:
    - "cn=users,dc=example,dc=com"
    - "cn=admins,dc=example,dc=com"
```

* ```es_users``` - Users can be declared here as yml. Two sub keys 'native' and 'file' determine the realm under which the user is created.  Beneath each of these keys users should be declared as yml entries. e.g.

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


* ```es_roles``` - Elasticsearch roles can be declared here as yml. Two sub keys 'native' and 'file' determine how the role is created i.e. either through a file or http(native) call.  Beneath each key list the roles with appropriate permissions, using the file based format described [here](https://www.elastic.co/guide/en/x-pack/current/file-realm.html) e.g.

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

If you don't have a license you can enable the 30-day trial by setting `es_xpack_trial` to `true`.

X-Pack configuration parameters can be added to the elasticsearch.yml file using the normal `es_config` parameter.

For a full example see [here](https://github.com/elastic/ansible-elasticsearch/blob/master/test/integration/xpack-upgrade.yml)

#### Important Note for Native Realm Configuration

In order for native users and roles to be configured, the role calls the Elasticsearch API.  Given security is installed this requires definition of two parameters:

* ```es_api_basic_auth_username``` - admin username
* ```es_api_basic_auth_password``` - admin password

These can either be set to a user declared in the file based realm, with admin permissions, or the default "elastic" superuser (default password is changeme).

#### X-Pack Security SSL/TLS

* To configure your cluster with SSL/TLS for HTTP and/or transport communications follow the [SSL/TLS setup procedure](https://github.com/elastic/ansible-elasticsearch/blob/master/docs/ssl-tls-setup.md)


### Additional Configuration

In addition to es_config, the following parameters allow the customization of the Java and Elasticsearch versions as well as the role behavior. Options include:

* ```oss_version```  Default `false`. Setting this to `true` will install the oss release of Elasticsearch (for version <7.11.0 only).
* `es_xpack_trial` Default `false`. Setting this to `true` will start the 30-day trail once the cluster starts.
* ```es_version``` (e.g. "7.13.2").
* ```es_api_host``` The host name used for actions requiring HTTP e.g. installing templates. Defaults to "localhost".
* ```es_api_port``` The port used for actions requiring HTTP e.g. installing templates. Defaults to 9200. **CHANGE IF THE HTTP PORT IS NOT 9200**
* ```es_api_basic_auth_username``` The Elasticsearch username for making admin changing actions. Used if Security is enabled. Ensure this user is admin.
* ```es_api_basic_auth_password``` The password associated with the user declared in `es_api_basic_auth_username`
* `es_delete_unmanaged_file` Default `true`. Set to false to keep file realm users that have been added outside of ansible.
* `es_delete_unmanaged_native` Default `true`. Set to false to keep native realm users that have been added outside of ansible.
* ```es_start_service``` (true (default) or false)
* ```es_plugins_reinstall``` (true or false (default) )
* ```es_plugins``` an array of plugin definitions e.g.:

  ```yaml
    es_plugins:
      - plugin: ingest-attachment
  ```

* ```es_path_repo``` Sets the whitelist for allowing local back-up repositories
* ```es_action_auto_create_index``` Sets the value for auto index creation, use the syntax below for specifying indexes (else true/false):
     es_action_auto_create_index: '[".watches", ".triggered_watches", ".watcher-history-*"]'
* ```es_allow_downgrades``` For development purposes only. (true or false (default) )
* ```es_java_install``` If set to true, Java will be installed. (false (default for 7.x) or true (default for 6.x))
* ```update_java``` Updates Java to the latest version. (true or false (default))
* ```es_max_map_count``` maximum number of VMA (Virtual Memory Areas) a process can own. Defaults to 262144.
* ```es_max_open_files``` the maximum file descriptor number that can be opened by this process. Defaults to 65536.
* ```es_debian_startup_timeout``` how long Debian-family SysV init scripts wait for the service to start, in seconds. Defaults to 10 seconds.
* ```es_use_repository``` Setting this to `false` will stop Ansible from using the official Elastic package from any repository configured on the system.
* ```es_add_repository``` Setting this to `false` will stop Ansible to add the official Elastic package repositories (if es_use_repository is true) if you want to use a repo already present.
* ```es_custom_package_url``` the URL to the rpm or deb package for Ansible to install. When using this you will also need to set `es_use_repository: false` and make sure that the `es_version` matches the version being installed from your custom URL. E.g. `es_custom_package_url: https://downloads.example.com/elasticsearch.rpm`

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

* ```es_restart_on_change``` - defaults to true.  If false, changes will not result in Elasticsearch being restarted.
* ```es_plugins_reinstall``` - defaults to false.  If true, all currently installed plugins will be removed from a node.  Listed plugins will then be re-installed.

To add, update or remove elasticsearch.keystore entries, use the following variable:

```yaml
# state is optional and defaults to present
es_keystore_entries:
- key: someKeyToAdd
  value: someValue
  state: present

- key: someKeyToUpdate
  value: newValue
  # state: present
  force: Yes

- key: someKeyToDelete
  state: absent
```



This role ships with sample templates located in the [test/integration/files/templates-7.x](https://github.com/elastic/ansible-elasticsearch/tree/master/test/integration/files/templates-7.x) directory. `es_templates_fileglob` variable is used with the Ansible [with_fileglob](http://docs.ansible.com/ansible/playbooks_loops.html#id4) loop. When setting the globs, be sure to use an absolute path.

### Proxy

To define proxy globally, set the following variables:

* ```es_proxy_host``` - global proxy host
* ```es_proxy_port``` - global proxy port

## Notes

* The role assumes the user/group exists on the server.  The elasticsearch packages create the default elasticsearch user.  If this needs to be changed, ensure the user exists.
* The playbook relies on the inventory_name of each host to ensure its directories are unique
* KitchenCI has been used for testing.  This is used to confirm images reach the correct state after a play is first applied.  We currently test the latest version of 7.x and 6.x on all supported platforms.
* The role aims to be idempotent.  Running the role multiple times, with no changes, should result in no state change on the server.  If the configuration is changed, these will be applied and Elasticsearch restarted where required.
* In order to run x-pack tests a license file with security enabled is required. Set the environment variable `ES_XPACK_LICENSE_FILE` to the full path of the license file prior to running tests. A trial license is appropriate and can be used by setting `es_xpack_trial` to `true`

## IMPORTANT NOTES RE PLUGIN MANAGEMENT

* If the ES version is changed, all plugins will be removed.  Those listed in the playbook will be re-installed.  This is behavior is required in ES 6.x.
* If no plugins are listed in the playbook for a node, all currently installed plugins will be removed.
* The role supports automatic detection of differences between installed and listed plugins - installing those listed but not installed, and removing those installed but not listed.   Should users wish to re-install plugins they should set es_plugins_reinstall to true.  This will cause all currently installed plugins to be removed and those listed to be installed.

## Questions on Usage

We welcome questions on how to use the role.  However, in order to keep the GitHub issues list focused on "issues" we ask the community to raise questions at https://discuss.elastic.co/c/elasticsearch.  This is monitored by the maintainers.
