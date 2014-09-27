#
# Cookbook Name:: bamboo
# Recipe:: tomcat_configuration
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
bamboo_version = Chef::Version.new(node['bamboo']['version'])

template "#{node['bamboo']['install_path']}/bamboo/bin/setenv.sh" do
  source 'setenv.sh.erb'
  owner node['bamboo']['user']
  mode '0755'
  notifies :restart, 'service[bamboo]', :delayed
end

template "#{node['bamboo']['install_path']}/bamboo/conf/server.xml" do
  if bamboo_version.major == 1
    source 'server.xml.erb'
  else
    source 'server-tomcat7.xml.erb'
  end
  owner node['bamboo']['user']
  mode '0640'
  variables :tomcat => settings['tomcat']
  notifies :restart, 'service[bamboo]', :delayed
end

template "#{node['bamboo']['install_path']}/bamboo/conf/web.xml" do
  if bamboo_version.major == 1
    source 'web.xml.erb'
  else
    source 'web-tomcat7.xml.erb'
  end
  owner node['bamboo']['user']
  mode '0644'
  notifies :restart, 'service[bamboo]', :delayed
end
