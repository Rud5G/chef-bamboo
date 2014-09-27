#
# Cookbook Name:: bamboo
# Recipe:: linux_standalone
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

settings = Bamboo.settings(node)

directory File.dirname(node['bamboo']['home_path']) do
  owner 'root'
  group 'root'
  mode 00755
  action :create
  recursive true
end

user node['bamboo']['user'] do
  comment 'Bamboo Service Account'
  home node['bamboo']['home_path']
  shell '/bin/bash'
  supports :manage_home => true
  system true
  action :create
end

execute 'Generating Self-Signed Java Keystore' do
  command <<-COMMAND
    #{node['java']['java_home']}/bin/keytool -genkey \
      -alias #{settings['tomcat']['keyAlias']} \
      -keyalg RSA \
      -dname 'CN=#{node['fqdn']}, OU=Example, O=Example, L=Example, ST=Example, C=US' \
      -keypass #{settings['tomcat']['keystorePass']} \
      -storepass #{settings['tomcat']['keystorePass']} \
      -keystore #{settings['tomcat']['keystoreFile']}
    chown #{node['bamboo']['user']}:#{node['bamboo']['user']} #{settings['tomcat']['keystoreFile']}
  COMMAND
  creates settings['tomcat']['keystoreFile']
  only_if { settings['tomcat']['keystoreFile'] == "#{node['bamboo']['home_path']}/.keystore" }
end

directory node['bamboo']['install_path'] do
  owner 'root'
  group 'root'
  mode 00755
  action :create
  recursive true
end

ark 'bamboo' do
  url node['bamboo']['url']
  prefix_root node['bamboo']['install_path']
  prefix_home node['bamboo']['install_path']
  checksum node['bamboo']['checksum']
  version node['bamboo']['version']
  owner node['bamboo']['user']
  group node['bamboo']['user']
end

if settings['database']['type'] == 'mysql'
  directory "#{node['bamboo']['home_path']}/lib" do
    owner node['bamboo']['user']
    group node['bamboo']['user']
    mode 00755
    action :create
  end

  mysql_connector_j "#{node['bamboo']['home_path']}/lib"
end
