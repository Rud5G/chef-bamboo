#
# Cookbook Name:: bamboo
# Recipe:: linux_installer
#
# Copyright (C) 2013 Triple-networks
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
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
  home    node['bamboo']['home_path']
  shell   '/bin/bash'
  supports :manage_home => true
  system  true
  action  :create
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

remote_file "#{Chef::Config[:file_cache_path]}/atlassian-bamboo-#{node['bamboo']['version']}.tar.gz" do
  source    node['bamboo']['url']
  checksum  node['bamboo']['checksum']
  mode      '0644'
  action    :create_if_missing
end

directory node['bamboo']['install_path'] do
  owner node['bamboo']['user']
  group node['bamboo']['user']
  mode 00755
  action :create
  recursive true
end

execute "Extracting Bamboo #{node['bamboo']['version']}" do
  cwd Chef::Config[:file_cache_path]
  command <<-COMMAND
    tar --strip-components=1 -zxf atlassian-bamboo-#{node['bamboo']['version']}.tar.gz -C #{node['bamboo']['install_path']}
    chown -R #{node['bamboo']['user']} #{node['bamboo']['install_path']}
  COMMAND
  creates "#{node['bamboo']['install_path']}/atlassian-bamboo"
end

if settings['database']['type'] == 'mysql'
  include_recipe 'mysql_connector'
  mysql_connector_j "#{node['bamboo']['install_path']}/lib"
end

template '/etc/init.d/bamboo' do
  source 'bamboo.init.erb'
  mode   '0755'
  notifies :restart, 'service[bamboo]', :delayed
end

service 'bamboo' do
  supports :status => true, :restart => true
  action :enable
  subscribes :restart, resources('java_ark[jdk]')
end


