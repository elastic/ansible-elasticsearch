# Multi-instance Support

Starting with ansible-elasticsearch:7.1.1, installing more than one instance of Elasticsearch **on the same host** is no longer supported.

See [554#issuecomment-496804929](https://github.com/elastic/ansible-elasticsearch/issues/554#issuecomment-496804929) for more details about why we removed it.

## Upgrade procedure

If you have single-instances hosts and want to upgrade from previous versions of the role:

### Procedure with data move

This procedure will allow you to move your data to the new standard paths (see [#581](https://github.com/elastic/ansible-elasticsearch/issues/581)):

1. Stop Elasticsearch before the migration

2. Migrate your data to the new standard paths:
```
# mv /etc/elasticsearch/${ES_INSTANCE_NAME}/* /etc/elasticsearch/ && rm -fr /etc/elasticsearch/${ES_INSTANCE_NAME}/
mv: overwrite '/etc/elasticsearch/elasticsearch.keystore'? y
# mv /var/lib/elasticsearch/${INVENTORY_HOSTNAME}-${ES_INSTANCE_NAME}/* /var/lib/elasticsearch/ && rm -fr /var/lib/elasticsearch/${INVENTORY_HOSTNAME}-${ES_INSTANCE_NAME}/
# ls /var/lib/elasticsearch/
nodes
# mv /var/log/elasticsearch/${INVENTORY_HOSTNAME}-${ES_INSTANCE_NAME}/* /var/log/elasticsearch/ && rm -fr /var/log/elasticsearch/${INVENTORY_HOSTNAME}-${ES_INSTANCE_NAME}/
# rm -fr /var/run/elasticsearch/${INVENTORY_HOSTNAME}-${ES_INSTANCE_NAME}/
```

3. Update playbook (remove `es_conf_dir`, `es_data_dirs`, `es_log_dir`, `es_pid_dir` and `es_instance_name` variables)

4. Update ansible-role to new version ([7.1.1](https://github.com/elastic/ansible-elasticsearch/releases/tag/7.1.1) at the time of writing) and deploy ansible-role

5. After ansible-role new deployment, you can do some cleanup of old Init file and Default file:

Example:
```
$ systemctl stop elasticsearch
$ mv /etc/elasticsearch/${ES_INSTANCE_NAME}/* /etc/elasticsearch/ && rm -fr /etc/elasticsearch/${ES_INSTANCE_NAME}/
mv: overwrite '/etc/elasticsearch/elasticsearch.keystore'? y
$ mv /var/lib/elasticsearch/${INVENTORY_HOSTNAME}-${ES_INSTANCE_NAME}/* /var/lib/elasticsearch/ && rm -fr /var/lib/elasticsearch/${INVENTORY_HOSTNAME}-${ES_INSTANCE_NAME}/
$ ls /var/lib/elasticsearch/
nodes
$ mv /var/log/elasticsearch/${INVENTORY_HOSTNAME}-${ES_INSTANCE_NAME}/* /var/log/elasticsearch/ && rm -fr /var/log/elasticsearch/${INVENTORY_HOSTNAME}-${ES_INSTANCE_NAME}/
$ rm -fr /var/run/elasticsearch/${INVENTORY_HOSTNAME}-${ES_INSTANCE_NAME}/
$ ansible-galaxy install --force elastic.elasticsearch,7.1.1
- changing role elastic.elasticsearch from 6.6.0 to 7.1.1
- downloading role 'elasticsearch', owned by elastic
- downloading role from https://github.com/elastic/ansible-elasticsearch/archive/7.1.1.tar.gz
- extracting elastic.elasticsearch to /home/jmlrt/.ansible/roles/elastic.elasticsearch
- elastic.elasticsearch (7.1.1) was installed successfully
$ ansible-playbook playbook.yml

...

TASK [elastic.elasticsearch : Create Directories]
ok: [localhost] => (item=/var/run/elasticsearch)
ok: [localhost] => (item=/var/log/elasticsearch)
changed: [localhost] => (item=/etc/elasticsearch)
ok: [localhost] => (item=/var/lib/elasticsearch)

TASK [elastic.elasticsearch : Copy Configuration File]
changed: [localhost]

TASK [elastic.elasticsearch : Copy Default File]
changed: [localhost]

TASK [elastic.elasticsearch : Copy jvm.options File]
changed: [localhost]

...

RUNNING HANDLER [elastic.elasticsearch : restart elasticsearch]
changed: [localhost]

...

PLAY RECAP
localhost                  : ok=26   changed=6    unreachable=0    failed=0    skipped=116  rescued=0    ignored=0
$ find /etc -name '${INVENTORY_HOSTNAME}-${ES_INSTANCE_NAME}*'
/etc/default/node1_elasticsearch
/etc/systemd/system/multi-user.target.wants/node1_elasticsearch.service
```

### Procedure without data move

This procedure will allow you to keep your data to the old paths:

1. Override these variables to match previous values:
```yaml
es_conf_dir: /etc/elasticsearch/${ES_INSTANCE_NAME}
es_data_dirs:
  - /var/lib/elasticsearch/${INVENTORY_HOSTNAME}-${ES_INSTANCE_NAME}
es_log_dir: /var/log/elasticsearch/${INVENTORY_HOSTNAME}-${ES_INSTANCE_NAME}
es_pid_dir: /var/run/elasticsearch/${INVENTORY_HOSTNAME}-${ES_INSTANCE_NAME}
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
