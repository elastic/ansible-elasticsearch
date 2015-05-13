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
    - elasticsearch
  tasks:
    - .... your tasks ...
```

or more complex..


```
---
hosts: my_host
  roles:
    - elasticsearch
  vars:
    java_packages:
      - "oracle-java7-installer"
    es_major_version: 1.4
    es_version: 1.4.4
    es_start_service: false
    es_plugins_reinstall: false
    es_plugins:
      - plugin: elasticsearch-cloud-aws
        version: 2.5.0
      - plugin: marvel
        version: latest
      - plugin: license
        version: latest
      - plugin: shield
        version: latest
      - plugin: elasticsearch-support-diagnostics
        version: latest
  tasks:
    - .... your tasks ...
```

Make sure your hosts are defined in your ```hosts``` file with the appropriate ```ansible_ssh_host```,  ```ansible_ssh_user``` and ```ansible_ssh_private_key_file``` values.

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
