name             'bamboo'
maintainer       'Triple-networks'
maintainer_email 'r.gravestein@triple-networks.com'
license          'Apache 2.0'
description      'Installs/Configures bamboo'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.1'

recipe            "bamboo", "Installs/configures Atlassian Bamboo"
#recipe            "bamboo::apache2", "Installs/configures Apache 2 as proxy (ports 80/443)"
recipe            "bamboo::database", "Installs/configures MySQL/Postgres server, database, and user for Bamboo"
recipe            "bamboo::linux_standalone", "Installs/configures Bamboo via Linux standalone archive"
#recipe            "bamboo::tomcat_configuration", "Configures Bamboo's built-in Tomcat"


# build
%w{ git mysql ntp php vim }.each do |cb|
  depends cb
end


# not tested: amazon centos redhat scientific
%w{ ubuntu }.each do |os|
  supports os
end

%w{ apache2 database mysql mysql_connector postgresql }.each do |cb|
  depends cb
end

%w{ java }.each do |cb|
  suggests cb
end
