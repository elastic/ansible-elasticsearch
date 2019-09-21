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
