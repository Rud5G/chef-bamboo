#
# Cookbook Name:: youwe-bamboo
# Attributes:: tomcat
#
# Copyright (C) 2014
#
#
#

default['tomcat']['java_options']         = '-XX:MaxPermSize=256M -Xmx768M -Djava.awt.headless=true'
default['tomcat']['keystore_password']    = 'iloverandompasswordsbutthiswilldo'
default['tomcat']['truststore_password']  = 'iloverandompasswordsbutthiswilldo'
