#
# Cookbook Name:: bamboo
# Attributes:: mysql
#
# Copyright (C) 2014
#
#
#

::Chef::Node.send(:include, Opscode::OpenSSL::Password)

default['mysql']['bind_address']                = '0.0.0.0'
default['mysql']['server_root_password']        = secure_password
default['mysql']['server_repl_password']        = secure_password
default['mysql']['server_debian_password']      = secure_password

