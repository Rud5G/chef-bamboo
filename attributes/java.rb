#
# Cookbook Name:: bamboo
# Attributes:: java
#
# Copyright (C) 2014
#
#
#

default['java']['install_flavor']                         = 'oracle'
default['java']['java_home']                              = '/usr/lib/jvm/java-7-oracle'
default['java']['jdk_version']                            = '7'
default['java']['oracle']['accept_oracle_download_terms'] = true
