# Multi-instance Support

Starting with ansible-elasticsearch:7.1.1, installing more than one instance of Elasticsearch **on the same host** is no longer supported.

See [554#issuecomment-496804929](https://github.com/elastic/ansible-elasticsearch/issues/554#issuecomment-496804929) for more details about why we removed it.

## Upgrade procedure

If you have single-instances hosts and want to upgrade from previous versions of the role:

1. Override these variables to match previous values:
```yaml
es_conf_dir: /etc/elasticsearch/{{ instance_name }}
es_data_dirs:
  - /var/lib/elasticsearch/{{ node_name }}-{{ instance_name }}
es_log_dir: /var/log/elasticsearch/{{ node_name }}-{{ instance_name }}
es_pid_dir: /var/run/elasticsearch/{{ node_name }}-{{ instance_name }}
```

2. Deploy ansible-role. **Even if these variables are overrided, Elasticsearch config file and default option file will change, which imply an Elasticsearch restart.**

3. After ansible-role new deployment, you can do some cleanup of old Init file and Default file.

Example:
```bash
$ ansible-playbook -e '{"es_conf_dir":"/etc/elasticsearch/node1","es_data_dirs":["/var/lib/elasticsearch/localhost-node1"],"es_log_dir":"/var/log/elasticsearch/localhost-node1","es_pid_dir":"/var/run/elasticsearch/localhost-node1"}' playbook.yml
...
TASK [elasticsearch : Create Directories] **********************************************************************************************************************************************************************************************************************
ok: [localhost] => (item=/var/run/elasticsearch/localhost-node1)
ok: [localhost] => (item=/var/log/elasticsearch/localhost-node1)
ok: [localhost] => (item=/etc/elasticsearch/node1)
ok: [localhost] => (item=/var/lib/elasticsearch/localhost-node1)

TASK [elasticsearch : Copy Configuration File] *****************************************************************************************************************************************************************************************************************
changed: [localhost]

TASK [elasticsearch : Copy Default File] ***********************************************************************************************************************************************************************************************************************
changed: [localhost]
...
PLAY RECAP *****************************************************************************************************************************************************************************************************************************************************
localhost                  : ok=32   changed=3    unreachable=0    failed=0

$ find /etc -name 'node1_elasticsearch*'
/etc/default/node1_elasticsearch
/etc/systemd/system/multi-user.target.wants/node1_elasticsearch.service
$ rm /etc/default/node1_elasticsearch /etc/systemd/system/multi-user.target.wants/node1_elasticsearch.service
```

## Workaround

If you use more than one instance of Elasticsearch on the same host (with different ports, directory and config files), you are still be able to install Elasticsearch 6.x and 7.x in multi-instance mode by using ansible-elasticsearch commit [25bd09f](https://github.com/elastic/ansible-elasticsearch/commit/25bd09f6835b476b6a078676a7d614489a6739c5) (last commit before multi-instance removal) and overriding `es_version` variable:

```sh
$ cat << EOF >> requirements.yml # require git
- src: https://github.com/elastic/ansible-elasticsearch
  version: 25bd09f
  name: elasticsearch
EOF
$ ansible-galaxy install -r requirements.yml
$ cat << EOF >> playbook.yml
- hosts: localhost
  roles:
    - role: elasticsearch
      vars:
        es_instance_name: "node1"
        es_version: 7.1.1 # or 6.8.0 for example
EOF
$ ansible-playbook playbook.yml
```
