# Install Apache Nutch as a dependency for other states
{% set apachenutchver = salt['pillar.get']('apachenutchver', '2.3.1') %}

extract_apachenutch:
  archive.extracted:
    - name: /vagrant
    - source: http://www-eu.apache.org/dist/nutch/{{ apachenutchver }}/apache-nutch-{{ apachenutchver }}-src.tar.gz
    - user: vagrant
    - group: vagrant
    - if_missing: /vagrant/apache-nutch-{{ apachenutchver }} # assuming the extracted tgz creates this dir
    - skip_verify: true

mongo_repo:
  pkgrepo.managed:
    - humanname: MongoDB
    - baseurl: https://repo.mongodb.org/yum/redhat/$releasever/mongodb-org/3.4/x86_64/
    - comments:
        - 'https://repo.mongodb.org/yum/redhat/$releasever/mongodb-org/3.4/x86_64/'
    - gpgcheck: 1
    - gpgkey: https://www.mongodb.org/static/pgp/server-3.4.asc

mongo_install:
  pkg.latest:
    - name: mongodb-org

mongodb:
  service.running:
    - name: mongod # assuming name of init file is /etc/init.d/mongodb
    - enable: True # start on boot, too

install_cron:
    pkg.installed:
      - name: cronie

install_cron:
    pkg.installed:
      - name: crontabs

install_ant:
    pkg.installed:
      - name: ant