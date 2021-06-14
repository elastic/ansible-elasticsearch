# Changelog

## 7.13.2

* 7.13.2 as default version.

## 7.13.1

* 7.13.1 as default version.

## 7.13.0

* 7.13.0 as default version.
* 6.8.16 as 6.x tested version


| PR | Author | Title |
| --- | --- | --- |
| [#796](https://github.com/elastic/ansible-elasticsearch/pull/796) | [@jmlrt](https://github.com/jmlrt) | Fails deployment when using tls without security  |
| [#745](https://github.com/elastic/ansible-elasticsearch/pull/745) | [@v1v](https://github.com/v1v) | Support ubuntu-20  |


## 7.12.1

* 7.12.1 as default version.


| PR | Author | Title |
| --- | --- | --- |
| [#793](https://github.com/elastic/ansible-elasticsearch/pull/793) | [@jmlrt](https://github.com/jmlrt) | [meta] update ubuntu-1804 during kitchen provisioning  |
| [#787](https://github.com/elastic/ansible-elasticsearch/pull/787) | [@tobiashuste](https://github.com/tobiashuste) | Stop plugin install to fail in check mode  |


## 7.12.0

* 7.12.0 as default version.
* 6.8.15 as 6.x tested version


| PR | Author | Title |
| --- | --- | --- |
| [#789](https://github.com/elastic/ansible-elasticsearch/pull/789) | [@jmlrt](https://github.com/jmlrt) | Use ES_JAVA_HOME instead of JAVA_HOME  |
| [#788](https://github.com/elastic/ansible-elasticsearch/pull/788) | [@jmlrt](https://github.com/jmlrt) | Fix deb and rpm url  |
| [#784](https://github.com/elastic/ansible-elasticsearch/pull/784) | [@jmlrt](https://github.com/jmlrt) | [meta] fix changelog after 7.11.2 release  |


## 7.11.2

* 7.11.2 as default version.

| PR | Author | Title |
| --- | --- | --- |
| [#771](https://github.com/elastic/ansible-elasticsearch/pull/771) | [@Bernhard-Fluehmann](https://github.com/Bernhard-Fluehmann) | Cleanup remove keystore entries  |
| [#782](https://github.com/elastic/ansible-elasticsearch/pull/782) | [@kuops](https://github.com/kuops) | Fix README.md Multi Node Server Installations  |
| [#777](https://github.com/elastic/ansible-elasticsearch/pull/777) | [@DanRoscigno](https://github.com/DanRoscigno) | Update ssl-tls-setup.md  |


## 7.11.1

* 7.11.1 as default version.
* 6.8.14 as 6.x tested version

| PR                                                                | Author                                                       | Title                                          |
|-------------------------------------------------------------------|--------------------------------------------------------------|------------------------------------------------|
| [#760](https://github.com/elastic/ansible-elasticsearch/pull/760) | [@jmlrt](https://github.com/jmlrt)                           | Add dedicated CI jobs for 6.x                  |
| [#761](https://github.com/elastic/ansible-elasticsearch/pull/761) | [@rubarclk](https://github.com/rubarclk)                     | Fix Elasticsearch 7.x deb url                  |
| [#769](https://github.com/elastic/ansible-elasticsearch/pull/769) | [@Bernhard-Fluehmann](https://github.com/Bernhard-Fluehmann) | Add support for elasticsearch-keystore entries |
| [#765](https://github.com/elastic/ansible-elasticsearch/pull/765) | [@jmlrt](https://github.com/jmlrt)                           | Refactor Kitchen tests                         |
| [#770](https://github.com/elastic/ansible-elasticsearch/pull/770) | [@jmlrt](https://github.com/jmlrt)                           | Remove OSS support for version >= 7.11.0       |
| [#779](https://github.com/elastic/ansible-elasticsearch/pull/779) | [@jmlrt](https://github.com/jmlrt)                           | Fix "list native roles" task                   |


## 7.10.2

* 7.10.2 as default version.


| PR | Author | Title |
| --- | --- | --- |
| [#753](https://github.com/elastic/ansible-elasticsearch/pull/753) | [@jmlrt](https://github.com/jmlrt) | Fix java install path when system has multiple java  |


## 7.10.1

* 7.10.1 as default version.


| PR | Author | Title |
| --- | --- | --- |
| [#747](https://github.com/elastic/ansible-elasticsearch/pull/747) | [@fourstepper](https://github.com/fourstepper) | Fix idempotency for both supported CentOS versions  |
| [#744](https://github.com/elastic/ansible-elasticsearch/pull/744) | [@v1v](https://github.com/v1v) | Support CentOS 8  |
| [#736](https://github.com/elastic/ansible-elasticsearch/pull/736) | [@jmlrt](https://github.com/jmlrt) | Fix test-kitchen net-scp-error  |


## 7.10.0

* 7.10.0 as default version.


| PR | Author | Title |
| --- | --- | --- |
| [#742](https://github.com/elastic/ansible-elasticsearch/pull/742) | [@jmlrt](https://github.com/jmlrt) | convert custom filter to python3  |
| [#741](https://github.com/elastic/ansible-elasticsearch/pull/741) | [@jmlrt](https://github.com/jmlrt) | [meta] clean deprecated bumper script  |
| [#740](https://github.com/elastic/ansible-elasticsearch/pull/740) | [@jmlrt](https://github.com/jmlrt) | fix some typos  |
| [#728](https://github.com/elastic/ansible-elasticsearch/pull/728) | [@smutel](https://github.com/smutel) | Improve the documentation for TLS  |
| [#739](https://github.com/elastic/ansible-elasticsearch/pull/739) | [@0xflotus](https://github.com/0xflotus) | fix: small error  |


## 7.9.3

* 7.9.3 as default version.
* 6.8.13 as 6.x tested version

| PR | Author | Title |
| --- | --- | --- |
| [#727](https://github.com/elastic/ansible-elasticsearch/pull/727) | [@smutel](https://github.com/smutel) | Add an option to not upload SSL/TLS certs  |
| [#726](https://github.com/elastic/ansible-elasticsearch/pull/726) | [@vielfarbig](https://github.com/vielfarbig) | Add note to only using es_data_dirs and es_log_dir for customizing th…  |


## 7.9.2 - 2020/09/24

* 7.9.2 as default version

| PR                                                                | Author                                 | Title                                    |
|-------------------------------------------------------------------|----------------------------------------|------------------------------------------|
| [#716](https://github.com/elastic/ansible-elasticsearch/pull/716) | [@lksnyder0](https://github.com/lksnyder0) | Use run_once for api related tasks        |

## 7.9.1 - 2020/09/03

* 7.9.1 as default version

| PR                                                                | Author                                 | Title                                    |
|-------------------------------------------------------------------|----------------------------------------|------------------------------------------|
| [#701](https://github.com/elastic/ansible-elasticsearch/pull/701) | [@suramon](https://github.com/suramon) | Fix running ansible in check mode        |
| [#703](https://github.com/elastic/ansible-elasticsearch/pull/703) | [@anisf](https://github.com/anisf)     | Add amazonlinux2 support                 |
| [#705](https://github.com/elastic/ansible-elasticsearch/pull/705) | [@andzs](https://github.com/andzs)     | Use sudo for users migration from <6.3.0 |

## 7.9.0 - 2020/08/18

* 7.9.0 as default version
* 6.8.12 as 6.x tested version


## 7.8.1 - 2020/07/28

* 7.8.1 as default version
* 6.8.11 as 6.x tested version

| PR                                                                | Author                                 | Title                                    |
|-------------------------------------------------------------------|----------------------------------------|------------------------------------------|
| [#701](https://github.com/elastic/ansible-elasticsearch/pull/701) | [@suramon](https://github.com/suramon) | Fix running ansible in check mode        |
| [#703](https://github.com/elastic/ansible-elasticsearch/pull/703) | [@anisf](https://github.com/anisf)     | Add amazonlinux2 support                 |
| [#705](https://github.com/elastic/ansible-elasticsearch/pull/705) | [@andzs](https://github.com/andzs)     | Use sudo for users migration from <6.3.0 |


## 7.8.0 - 2020/06/18

* 7.8.0 as default version

| PR                                                                | Author                             | Title                          |
|-------------------------------------------------------------------|------------------------------------|--------------------------------|
| [#653](https://github.com/elastic/ansible-elasticsearch/pull/653) | [@jmlrt](https://github.com/jmlrt) | Fix Xpack features refactoring |
| [#699](https://github.com/elastic/ansible-elasticsearch/pull/699) | [@jmlrt](https://github.com/jmlrt) | Add Debian 10 support          |

## 7.7.1 - 2020/06/04

* 7.7.1 as default version
* 6.8.10 as 6.x tested version

| PR                                                                | Author                                             | Title                            |
|-------------------------------------------------------------------|----------------------------------------------------|----------------------------------|
| [#693](https://github.com/elastic/ansible-elasticsearch/pull/693) | [@jurim76](https://github.com/jurim76)             | Fix typo                         |
| [#697](https://github.com/elastic/ansible-elasticsearch/pull/697) | [@ballesterosam](https://github.com/ballesterosam) | Support limitnofile with systemd |

## 7.7.0 - 2020/05/13

* 7.7.0 as default version
* 6.8.9 as 6.x tested version
* Updated Ansible minimal version from 2.4.2 to 2.5.0 in [#690](https://github.com/elastic/ansible-elasticsearch/pull/690)

| PR                                                                | Author                                                 | Title                                            |
|-------------------------------------------------------------------|--------------------------------------------------------|--------------------------------------------------|
| [#689](https://github.com/elastic/ansible-elasticsearch/pull/689) | [@CristianPupazan](https://github.com/CristianPupazan) | Remove port from `initial_master_nodes` setting  |
| [#681](https://github.com/elastic/ansible-elasticsearch/pull/691) | [@jmlrt](https://github.com/jmlrt)                     | Update jvm options with default values for 7.6.0 |


## 7.6.2 - 2020/03/31

* 7.6.2 as default version
* 6.8.8 as 6.x tested version

| PR                                                                | Author                               | Title                                                          |
|-------------------------------------------------------------------|--------------------------------------|----------------------------------------------------------------|
| [#678](https://github.com/elastic/ansible-elasticsearch/pull/678) | [@nduytg](https://github.com/nduytg) | Update security task files                                     |
| [#681](https://github.com/elastic/ansible-elasticsearch/pull/681) | [@timdev](https://github.com/timdev) | Introduce `es_java_home` variable to allow setting `JAVA_HOME` |
| [#682](https://github.com/elastic/ansible-elasticsearch/pull/682) | [@jmlrt](https://github.com/jmlrt)   | Export `VERSION` variable to make subshell                     |


## 7.6.1 - 2020/03/04

* 7.6.1 as default version

| PR                                                                | Author                                           | Title                        |
|-------------------------------------------------------------------|--------------------------------------------------|------------------------------|
| [#674](https://github.com/elastic/ansible-elasticsearch/pull/674) | [@HadrienPatte](https://github.com/HadrienPatte) | Fix typos in README          |
| [#672](https://github.com/elastic/ansible-elasticsearch/pull/672) | [@pgassmann](https://github.com/pgassmann)       | Fix check mode               |
| [#676](https://github.com/elastic/ansible-elasticsearch/pull/676) | [@nduytg](https://github.com/nduytg)             | Lint elasticsearch-xpack.yml |


## 7.6.0 - 2020/02/11

* 7.6.0 as default version

| PR                                                                | Author                                                 | Title                                                 |
|-------------------------------------------------------------------|--------------------------------------------------------|-------------------------------------------------------|
| [#667](https://github.com/elastic/ansible-elasticsearch/pull/667) | [@dependabot[bot]](https://github.com/apps/dependabot) | Bump rubyzip from 1.2.2 to 2.0.0                      |
| [#671](https://github.com/elastic/ansible-elasticsearch/pull/671) | [@haslersn](https://github.com/haslersn)               | Remove whitespaces before newmines                    |
| [#669](https://github.com/elastic/ansible-elasticsearch/pull/669) | [@rs-garrick](https://github.com/rs-garrick)           | Several tasks in elasticsearch-ssl.yml missing become |


## 7.5.2 - 2020/01/21

* 7.5.2 as default version

| PR                                                                | Author                                 | Title                                                             |
|-------------------------------------------------------------------|----------------------------------------|-------------------------------------------------------------------|
| [#648](https://github.com/elastic/ansible-elasticsearch/pull/648) | [@jmlrt](https://github.com/jmlrt)     | add proxy options to ES_JAVA_OPTS when defined with es_proxy_host |
| [#657](https://github.com/elastic/ansible-elasticsearch/pull/657) | [@jakommo](https://github.com/jakommo) | switched relative URLs to absolute URLs                           |
| [#664](https://github.com/elastic/ansible-elasticsearch/pull/664) | [@jmlrt](https://github.com/jmlrt)     | bump ruby to 2.5.7                                                |


## 7.5.1 - 2019/12/18

* 7.5.1 as default version
* 6.8.6 as 6.x tested version

| PR                                                                | Author                             | Title                                                    |
|-------------------------------------------------------------------|------------------------------------|----------------------------------------------------------|
| [#643](https://github.com/elastic/ansible-elasticsearch/pull/643) | [@jmlrt](https://github.com/jmlrt) | Set templates task to run only if `es_templates` is true |
| [#647](https://github.com/elastic/ansible-elasticsearch/pull/647) | [@jmlrt](https://github.com/jmlrt) | Fix when condition for es_ssl_certificate_authority      |


## 7.5.0 - 2019/12/09

* 7.5.0 as default version
* 6.8.5 as 6.x tested version

### Breaking changes

#### Removing the MAX_THREAD settings

Ansible-elasticsearch 7.5.0 is removing the option to customize the maximum number of threads the process can start in [#637](https://github.com/elastic/ansible-elasticsearch/pull/637/files#diff-04c6e90faac2675aa89e2176d2eec7d8L408).
We discovered that this option wasn't working anymore since multi-instance support removal in ansible-elasticsearch 7.1.1.
This option will be added back in a following release if it's still relevant regarding latest Elasticsearch evolutions.

#### Changes about configuration files

Ansible-elasticsearch 7.5.0 is updating the configuration files provided by this role in [#637](https://github.com/elastic/ansible-elasticsearch/pull/637) which contained some otions deprecated in 6.x and 7.x:
- `/etc/default/elasticsearch`|`/etc/sysconfig/elasticsearch`: the new template reflect the configuration file provided by Elasticsearch >= 6.x, the parameter we removed were already not used in 6.x and 7.x
- `/etc/elasticsearch/jvm.options`: the new template reflect the configuration files provided by Elasticsearch >= 6.x
- `/etc/elasticsearch/log4j2.properties`:
  - We removed `log4j2.properties.j2` template from this Ansible role as it was a static file not bringing any customization specific to some ansible variable.
  - Deployment of this Ansible role on new servers will get the default `log4j2.properties` provided by Elastisearch without any override.
  - **WARNING**: For upgrade scenarios where this file was already managed by previous versions of ansible-elasticsearch, this file will become unmanaged and won't be updated by default. If you wish to update it to 7.5 version, you can retrieve it [here](https://github.com/elastic/elasticsearch/blob/7.5/distribution/src/config/log4j2.properties) and use this file with `es_config_log4j2` Ansible variable (see below).

##### How to override configuration files provided by ansible-elasticsearch?

You can now override the configuration files with your own versions by using the following Ansible variables:
- `es_config_default: "elasticsearch.j2"`: replace `elasticsearch.j2` by your own template to use a custom `/etc/default/elasticsearch`|`/etc/sysconfig/elasticsearch` configuration file
- `es_config_jvm: "jvm.options.j2"`: replace `jvm.options.j2` by your own template to use a custom `/etc/elasticsearch/jvm.options` configuration file
- `es_config_log4j2: ""`: set this variable to the path of your own template to use a custom `/etc/elasticsearch/log4j2.properties` configuration file

### SSL/TLS Support

Ansible-elasticsearch is now supporting SSL/TLS encryption. Please refer to [X-Pack Security SSL/TLS](https://github.com/elastic/ansible-elasticsearch/blob/master/docs/ssl-tls-setup.md) to configure it.

| PR                                                                | Author                                         | Title                                        |
|-------------------------------------------------------------------|------------------------------------------------|----------------------------------------------|
| [#625](https://github.com/elastic/ansible-elasticsearch/pull/625) | [@jmlrt](https://github.com/jmlrt)             | Add bumper script                            |
| [#575](https://github.com/elastic/ansible-elasticsearch/pull/575) | [@flyinggecko](https://github.com/flyinggecko) | Docs: Fix name of elasticsearch ansible role |
| [#629](https://github.com/elastic/ansible-elasticsearch/pull/629) | [@patsevanton](https://github.com/patsevanton) | Add cluster.initial_master_nodes             |
| [#620](https://github.com/elastic/ansible-elasticsearch/pull/620) | [@pemontto](https://github.com/pemontto)       | Add SSL/TLS support                          |
| [#630](https://github.com/elastic/ansible-elasticsearch/pull/630) | [@jmlrt](https://github.com/jmlrt)             | Indent yaml for config file                  |
| [#636](https://github.com/elastic/ansible-elasticsearch/pull/636) | [@jmlrt](https://github.com/jmlrt)             | Bump elasticsearch to 6.8.5 and 7.4.2        |
| [#637](https://github.com/elastic/ansible-elasticsearch/pull/637) | [@jmlrt](https://github.com/jmlrt)             | Use default config files                     |


## 7.4.1 - 2019/10/23

* 7.4.1 as default version
* 6.8.4 as 6.x tested version

| PR                                                                | Author                             | Title                                              |
|-------------------------------------------------------------------|------------------------------------|----------------------------------------------------|
| [#617](https://github.com/elastic/ansible-elasticsearch/pull/617) | [@jmlrt](https://github.com/jmlrt) | Use systemd ansible module for daemon-reload       |
| [#618](https://github.com/elastic/ansible-elasticsearch/pull/618) | [@jmlrt](https://github.com/jmlrt) | Fix probot newlines                                |
| [#619](https://github.com/elastic/ansible-elasticsearch/pull/619) | [@jmlrt](https://github.com/jmlrt) | Fix python AttributeError + format code with black |


## 7.4.0 - 2019/10/01

* 7.4.0 as default version
* Remove compatibility with versions < 6.3

| PR                                                                | Author                                                   | Title                                                                                |
|-------------------------------------------------------------------|----------------------------------------------------------|--------------------------------------------------------------------------------------|
| [#575](https://github.com/elastic/ansible-elasticsearch/pull/575) | [@flyinggecko](https://github.com/flyinggecko)           | Fix name of Elasticsearch Ansible role                                               |
| [#578](https://github.com/elastic/ansible-elasticsearch/pull/578) | [@jmlrt](https://github.com/jmlrt)                       | Fix `dict object has no attribute dict_keys` issue with Python3                      |
| [#588](https://github.com/elastic/ansible-elasticsearch/pull/588) | [@broferek](https://github.com/broferek)                 | Move `userid` and `groupid` in a different place in the role                         |
| [#591](https://github.com/elastic/ansible-elasticsearch/pull/591) | [@Crazybus](https://github.com/Crazybus)                 | Add back in `force_basic_auth` for all http requests                                 |
| [#582](https://github.com/elastic/ansible-elasticsearch/pull/582) | [@ktibi](https://github.com/ktibi)                       | Allow disable Elastic official repository setup                                      |
| [#593](https://github.com/elastic/ansible-elasticsearch/pull/593) | [@jmlrt](https://github.com/jmlrt)                       | Bunch of small fixes                                                                 |
| [#595](https://github.com/elastic/ansible-elasticsearch/pull/595) | [@broferek](https://github.com/broferek)                 | Set `limitMEMLOCK` for OS using Systemd                                              |
| [#600](https://github.com/elastic/ansible-elasticsearch/pull/600) | [@titan-architrave](https://github.com/titan-architrave) | Always gather the `es_major_version` variables                                       |
| [#605](https://github.com/elastic/ansible-elasticsearch/pull/605) | [@jmlrt](https://github.com/jmlrt)                       | Add doc for migration with data move                                                 |
| [#601](https://github.com/elastic/ansible-elasticsearch/pull/601) | [@LukeRoz](https://github.com/LukeRoz)                   | Removing package version hold when `es_version_hold: false`                          |
| [#612](https://github.com/elastic/ansible-elasticsearch/pull/612) | [@jmlrt](https://github.com/jmlrt)                       | Add Probot config to manage stale issues/pr                                          |
| [#614](https://github.com/elastic/ansible-elasticsearch/pull/614) | [@jmlrt](https://github.com/jmlrt)                       | Describe how to select a different elasticsearch version                             |
| [#609](https://github.com/elastic/ansible-elasticsearch/pull/609) | [@jmlrt](https://github.com/jmlrt)                       | No more 6.3 compatibility + Use default files permissions from Elasticsearch package |
| [#510](https://github.com/elastic/ansible-elasticsearch/pull/510) | [@verboEse](https://github.com/verboEse)                 | Don't fetch APT key if existent                                                      |


## 7.1.1 - 2019/06/04

### Breaking changes

#### End of multi-instance support

* Starting with ansible-elasticsearch:7.1.1, installing more than one instance of Elasticsearch **on the same host** is no longer supported.
* Configuration, datas, logs and PID directories are now using standard paths like in the official Elasticsearch packages.

* If you use only one instance but want to upgrade from an older ansible-elasticsearch version, follow [upgrade procedure](./docs/multi-instance.md#upgrade-procedure)
* If you install more than one instance of Elasticsearch on the same host (with different ports, directory and config files), **do not update to ansible-elasticsearch >= 7.1.1**, please follow this [workaround](./docs/multi-instance.md#workaround) instead.
* For multi-instances use cases, we are now recommending Docker containers using our official images (https://www.elastic.co/guide/en/elasticsearch/reference/current/docker.html).

#### Moved some security features to basic

You can now using basic authentication by overriding `es_api_basic_auth_username` and `es_api_basic_auth_password` variables without providing a license file.

### Features

* 7.1.1 as default Elasticsearch version
* [#539](https://github.com/elastic/ansible-elasticsearch/pull/539) and [#542](https://github.com/elastic/ansible-elasticsearch/pull/542) - @grzegorznowak - Make ansible role compatible with ansible [check mode](https://docs.ansible.com/ansible/latest/user_guide/playbooks_checkmode.html)
* [#558](https://github.com/elastic/ansible-elasticsearch/pull/558) - @jmlrt - Add support for Elasticsearch 7.x, remove 5.x support and update tests
* [#560](https://github.com/elastic/ansible-elasticsearch/pull/560) - @jmlrt - Use default xpack features and remove system_key deprecated feature
* [#562](https://github.com/elastic/ansible-elasticsearch/pull/562) - @hamishforbes - Allow to customize instance suffix
* [#566](https://github.com/elastic/ansible-elasticsearch/pull/566) - @jmlrt - Remove multi-instances support
* [#567](https://github.com/elastic/ansible-elasticsearch/pull/567) - @jmlrt - Remove file scripts deprecated feature
* [#568](https://github.com/elastic/ansible-elasticsearch/pull/568) - @jmlrt - Skip Java install for Elasticsearch 7.x (java is now embeded)

### Fixes

* [#543](https://github.com/elastic/ansible-elasticsearch/pull/543) - @victorgs - Fix typo in Makefile
* [#546](https://github.com/elastic/ansible-elasticsearch/pull/546) - @thiagonache - Fix README example
* [#550](https://github.com/elastic/ansible-elasticsearch/pull/550) - @pemontto - Fix template conditional
* [#556](https://github.com/elastic/ansible-elasticsearch/pull/556) - @jmlrt - Fix debian-8 test
* [#557](https://github.com/elastic/ansible-elasticsearch/pull/557) - @jmlrt - Bump gem dependencies to fix [CVE-2018-1000544](https://nvd.nist.gov/vuln/detail/CVE-2018-1000544) and [CVE-2018-1000201](https://nvd.nist.gov/vuln/detail/CVE-2018-1000201)
* [#564](https://github.com/elastic/ansible-elasticsearch/pull/564) - @jmlrt - Bump all gem dependencies to fix kitchen tests


## 6.6.0 - 2019/01/29

### Features

* 6.6.0  as default Elasticsearch version
* [#521](https://github.com/elastic/ansible-elasticsearch/pull/521) - @Crazybus - Allow switching between oss and standard packages
* [#528](https://github.com/elastic/ansible-elasticsearch/pull/528) - @Fra-nk - Use systemd's RequiresMountsFor
* [#530](https://github.com/elastic/ansible-elasticsearch/pull/530) - @lde - Use dpkg_selections to lock Elasticsearch version

### Fixes

* [#513](https://github.com/elastic/ansible-elasticsearch/pull/513) - @kakoni - Fix typo in elasticsearch-parameters.yml
* [#522](https://github.com/elastic/ansible-elasticsearch/pull/522) - @SlothOfAnarchy - Fix package download URL
* [#526](https://github.com/elastic/ansible-elasticsearch/pull/526) - @Fra-nk - Allow not installing Elasticsearch deb repository key
* [#527](https://github.com/elastic/ansible-elasticsearch/pull/527) - @katsukamaru - Execute java version check in check mode


## 6.5.1.1 - 2018/11/27

### Fixes

* [#516](https://github.com/elastic/ansible-elasticsearch/pull/516) - @Crazybus - Only attempt to copy the old users file if it actually exists


## 6.5.1 - 2018/11/26

### Features

* 6.5.1  as default Elasticsearch version

### Fixes

* [#487](https://github.com/elastic/ansible-elasticsearch/pull/487) - @lazouz - Disable check mode to make install plugins idempotent
* [#501](https://github.com/elastic/ansible-elasticsearch/pull/501) - @kaxil - Make the order of configs consistent for comparing
* [#497](https://github.com/elastic/ansible-elasticsearch/pull/497) - @Crazybus - Document es_use_repository and es_custom_package_url
* [#504](https://github.com/elastic/ansible-elasticsearch/pull/504) - @victorgs - Using tests as filters is deprecated
* [#493](https://github.com/elastic/ansible-elasticsearch/pull/493) - @Crazybus - Only use the first found java version if there are multiple installed


## 6.4.0 - 2018/08/24

### Features

* 6.4.0 as default Elasticsearch version

### Fixes

* [#484](https://github.com/elastic/ansible-elasticsearch/pull/484) - @kimoto - Fix downgrading Elasticsearch on RedHat hosts
* [#476](https://github.com/elastic/ansible-elasticsearch/pull/476) - @Crazybus - Fix version locking for the elasticsearch-oss package


## 6.3.1 - 2018/07/05

### Features

* 6.3.1 as default Elasticsearch version


## 6.3.0.1 - 2018/06/28

### Fixes

* [#460](https://github.com/elastic/ansible-elasticsearch/pull/460) - @toadjaune - Make sure ansible doesn't fail if the default systemd service file doesn't exist
* [#461](https://github.com/elastic/ansible-elasticsearch/pull/461) - @bilsch - Add missing become root in tasks that require root access


## 6.3.0 - 2018/06/18

### Breaking changes

Elasticsearch 6.3 includes several big changes that are reflected in this role.
When upgrading from module versions prior to 6.3, there are a number of upgrade considerations to take into account:

* This role defaults to the upstream package repositories, which now include X-Pack bundled by default. To preserve previous behavior which does _not_ include X-Pack be sure to explicitly set `es_enable_xpack: false` which will install the `elasticsearch-oss` package.
* Great care has been taken in making sure that all upgrade paths work, however as always please take extra caution when upgrading and test in a non-production environment. New automated tests have been added to make sure that the following upgrade paths work:
  * oss to oss
  * oss to xpack
  * xpack to xpack
* X-Pack configuration files which used to be in `${ES_PATH_CONF}/x-pack` are now in `${ES_PATH_CONF}/`. If you have any configuration files in this directory not managed by ansible you will need to move them manually.

#### Features

* Integration testing has been refactored in [#457](https://github.com/elastic/ansible-elasticsearch/pull/457). This removed a lot of duplicate tests and added new tests to make sure all upgrade paths work.
* It is now possible to test Elasticsearch snapshot builds by setting `es_use_snapshot_release` to `true`

#### Fixes

* Installing `es_plugins` from custom urls is now idempotent. Previously the plugin name was being compared to the url which meant it would be reinstalled every time ansible was run because they didn't match

#### Pull requests

* [#452](https://github.com/elastic/ansible-elasticsearch/pull/452) - @Crazybus - Add initial 6.3 support
* [#454](https://github.com/elastic/ansible-elasticsearch/pull/454) - @Crazybus - Move jenkins matrix file into the repo so test suites are controlled via the pull request workflow
* [#455](https://github.com/elastic/ansible-elasticsearch/pull/455) - @Crazybus - Add automated test for upgrading from oss to oss
* [#457](https://github.com/elastic/ansible-elasticsearch/pull/457) - @Crazybus - Refactor integration tests to remove duplication and add extra suites to make sure all upgrade paths are covered


## 6.2.4.1 - 2018/06/14

Patch release requested by @average-joe in #453

#### Pull requests

* [#445](https://github.com/elastic/ansible-elasticsearch/pull/445) - @gekkeharry13 - Added configuration options for configuring x-pack notifications via email with some other nice fixes.
* [#450](https://github.com/elastic/ansible-elasticsearch/pull/450) - @Crazybus - improving some flakey tests which were randomly failing.
* [#447](https://github.com/elastic/ansible-elasticsearch/pull/447) - @chaintng - Fix to make sure sudo is used when running `update-alternatives` for java.
* [#423](https://github.com/elastic/ansible-elasticsearch/pull/423) - @eRadical - Fixing the until condition being used when installing rpms from a custom repository.


## 6.2.4 - 2018/04/24

* `6.2.4` and `5.6.9`  as the default versions.


## 6.2.3 - 2018/04/21

* Thanks to @cl0udf0x for adding proper names to all tasks which were unnamed [#417](https://github.com/elastic/ansible-elasticsearch/pull/417)
* Thanks @cyrilleverrier  for having a keen eye and spotting this typo. [#432](https://github.com/elastic/ansible-elasticsearch/pull/432)


## 6.2.2 - 2018/02/22

* `6.2.2` and `5.6.8` as the default versions
* Thanks to @pemontto for fixing up all of the ansible conditional logic https://github.com/elastic/ansible-elasticsearch/pull/429
* Thanks @cyrilleverrier for https://github.com/elastic/ansible-elasticsearch/pull/427 which makes sure x-pack settings are not in the config file when x-pack isn't enabled


## 6.1.3 - 2018/02/01

* `6.x` is now the default `es_major_version` with `6.1.3` as the default `es_version`
* Special thanks to @shribigb, @toddlers and @remil1000 for their efforts in getting `6.x` support working!
* `.kitchen.yml` has been updated to allow testing both `6.x` and `5.x` versions
* A new [Jenkins job](https://devops-ci.elastic.co/job/elastic+ansible-elasticsearch+pull-request/) has been added for pull requests to automatically test all combinations of `6.x` and `5.x` on ubuntu-1404, ubuntu-1604, debian-8 and centos-7 with the various test suites.


## 5.5.1 - 2017/08/20

* Fixes with respect to issues on restart.
* 5.5.1 update with supporting package scripts.
* Documentation clarification.
* Fixes for loading of templates
* Support for ML
* Ability to install x-pack from remote.
