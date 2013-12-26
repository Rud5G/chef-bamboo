#
# Cookbook Name:: bamboo
# Recipe:: default
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

# debug / build
include_recipe 'bamboo::build'

# platform settings
platform = 'windows' if node['platform_family'] == 'windows'
platform ||= 'linux'

settings = Bamboo.settings(node)

include_recipe 'bamboo::database' if settings['database']['host'] == 'localhost'
include_recipe "bamboo::#{platform}_#{node['bamboo']['install_type']}"
include_recipe 'bamboo::configuration'



  #include_recipe 'bamboo::tomcat_configuration'
  #include_recipe 'bamboo::apache2'



