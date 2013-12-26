#
# Cookbook Name:: bamboo
# Recipe:: build
#
# Copyright (C) 2013 Triple-networks
# 
# Licensed under the Apache License, Version 2.0 (the 'License');
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#    http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an 'AS IS' BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe 'vim'
include_recipe 'git'
include_recipe 'ntp'



include_recipe 'apache2'
include_recipe 'mysql::client'
include_recipe 'mysql::server'
include_recipe 'php'
include_recipe 'php::module_mysql'

%w{ php5 php5-cli php5-curl php5-dev php5-mcrypt php5-mhash php5-mysql php5-xmlrpc php5-xsl phpmyadmin }.each do |cb|
  package cb do
    action :install
  end
end

