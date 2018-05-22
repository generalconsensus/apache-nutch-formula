# Install Apache Nutch as a dependency for other states
{% set apachenutchver = salt['pillar.get']('apachenutchver', '2.3.1') %}
# Install Java as a dependency for other states
{% set java_home = salt['pillar.get']('java', '/usr/lib/jvm/java-1.7.0') %}


extract_apachenutch:
  archive.extracted:
    - name: /vagrant
    - source: http://www-eu.apache.org/dist/nutch/{{ apachenutchver }}/apache-nutch-{{ apachenutchver }}-src.tar.gz
    - user: vagrant
    - group: vagrant
    - if_missing: /vagrant/apache-nutch-{{ apachenutchver }} # assuming the extracted tgz creates this dir
    - skip_verify: true


# gora.properties
/vagrant/apache-nutch-{{ apachenutchver }}/gora.properties:
  file.managed:
    - source: salt://apache-nutch/files/gora.properties

# ivy.xml
/vagrant/apache-nutch-{{ apachenutchver }}/ivy.xml:
  file.managed:
    - source: salt://apache-nutch/files/ivy.xml

# nutch-site.xml
/vagrant/apache-nutch-{{ apachenutchver }}/nutch-site.xml:
  file.managed:
    - source: salt://apache-nutch/files/nutch-site.xml
    
# regex-urlfilter.txt
/vagrant/apache-nutch-{{ apachenutchver }}/conf/regex-urlfilter.txt:
  file.managed:
    - source: salt://apache-nutch/files/regex-urlfilter.txt

# urls/seeds.txt
/vagrant/apache-nutch-{{ apachenutchver }}/urls/seeds.txt:
  file.managed:
    - source: salt://apache-nutch/files/seeds.txt

# .gitignore
/vagrant/apache-nutch-{{ apachenutchver }}/.gitignore:
  file.managed:
    - source: salt://apache-nutch/files/.gitignore   

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

install_crontabs:
    pkg.installed:
      - name: crontabs

install_ant:
    pkg.installed:
      - name: ant


# File.append searches the file for your text before it appends so it won't append multiple times
root_java_home:
  file.append:
    - name: /root/.bash_profile
    - text: export JAVA_HOME={{ java_home }}

# File.append searches the file for your text before it appends so it won't append multiple times
vagrant_java_home:
  file.append:
    - name: /vagrant/.bash_profile
    - text: export JAVA_HOME={{ java_home }}
