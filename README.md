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
      - "openjdk-7-jre-headless"
    es_major_version: 1.7
    es_version: 1.7.0
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

Make sure your hosts are defined in your ```hosts``` file with the appropriate ```ansible_ssh_host```,  ```ansible_ssh_user``` and ```ansible_ssh_private_key_file``` values.

Then run it:

```
ansible-playbook -i hosts ./your-playbook.yml
```

## Configuration
You can add the role without any customisation and it will by default install Java and Elasticsearch, without any plugins.

#### Description of the variables available.

```es_major_version``` (e.g. `1.7` )

Which major version to use. This is also used to define which the repository is used.

```es_version``` (e.g. `1.7.0`)

Which minor version to use.

```es_start_service``` (true (default) or false)

Should elasticsearch be started after installation?

```es_use_repository``` (true (default) or false )

Should elasticsearch be installed from a repository or from a url download. If false package will be downloaded from https://download.elastic.co/elasticsearch/elasticsearch/elasticsearch.... You can also specify `es_custom_package_url` with a url to a custom package.

```es_version_lock``` (true or false (default))

This will lock the elasticsearch version using `yum versionlock` or `apt-mark hold`.

```es_scripts``` (true or false (default))

If true you need to supply a files/scripts/ folder with your scripts, inside the role directory. The folder and all files will be copied to `/etc/elasticsearch/scripts`. You can also provide a scripts/ folder at toplevel of your playbook.


```es_plugins_reinstall``` (true or false (default) )

Schould plugins be reinstalled?

```es_plugins``` (an array of plugin definitons e.g.:)

```
  es_plugins:
  - plugin: elasticsearch-cloud-aws
    version: 2.5.0
```

`java_debian`

name of the java debian package to use (e.g. `openjdk-7-jre-headless`) 

`java_rhel`

name of the java rhel package to use (e.g. `java-1.8.0-openjdk.x86_64`)
