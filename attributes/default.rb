#
# Cookbook Name:: bamboo
# Attributes:: default
#
# Copyright 2012
#
# Licensed under the Apache License, Version 2.0 (the 'License');
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an 'AS IS' BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#


default[:ntp][:servers]             = %w{ 0.nl.pool.ntp.org 1.nl.pool.ntp.org 2.nl.pool.ntp.org 3.nl.pool.ntp.org }


default['bamboo']['backup_home']    = true
default['bamboo']['backup_install'] = true
default['bamboo']['version']        = '5.1.1'
default['bamboo']['install_type']   = 'standalone'
default['bamboo']['install_path']   = '/opt/atlassian/bamboo'
default['bamboo']['home_path']      = '/var/atlassian/application-data/bamboo'
default['bamboo']['user']           = 'bamboo'
default['bamboo']['home_backup']    = '/tmp/atlassian-bamboo-home-backup.tgz'
default['bamboo']['install_backup'] = '/tmp/atlassian-bamboo-backup.tgz'
default['bamboo']['url_base']       = 'http://www.atlassian.com/software/bamboo/downloads/binary/atlassian-bamboo'

if node['kernel']['machine'] == 'x86_64'
  default['bamboo']['arch'] = 'x64'
else
  default['bamboo']['arch'] = 'x32'
end

case node['platform_family']
  when 'windows'
    # log exception
  else
    case node['bamboo']['install_type']
      when 'standalone'
        default['bamboo']['url']      = "#{node['bamboo']['url_base']}-#{node['bamboo']['version']}.tar.gz"
        default['bamboo']['checksum'] =
          case node['bamboo']['version']
            when '5.1.1'; '8ebb5fd045cef2765fde13e3f3b88e48da7262f2508ce209a24e9a446c761b8b'
            when 'x.x.x'; ''
          end
    end
end

default['bamboo']['database']['host']       = 'localhost'
default['bamboo']['database']['name']       = 'bamboo'
default['bamboo']['database']['password']   = 'changeit'
default['bamboo']['database']['port']       = 3306
default['bamboo']['database']['type']       = 'mysql'
default['bamboo']['database']['user']       = 'bamboo'

default['bamboo']['jvm']['minimum_memory']  = '256m'
default['bamboo']['jvm']['maximum_memory']  = '768m'
default['bamboo']['jvm']['maximum_permgen'] = '256m'
default['bamboo']['jvm']['java_opts']       = ''
default['bamboo']['jvm']['support_args']    = ''

case node['platform_family']
  when 'rhel'
    default['bamboo']['apache2']['ssl']['certificate_file'] = '/etc/pki/tls/certs/localhost.crt'
    default['bamboo']['apache2']['ssl']['key_file']         = '/etc/pki/tls/private/localhost.key'
  else
    default['bamboo']['apache2']['ssl']['certificate_file'] = '/etc/ssl/certs/ssl-cert-snakeoil.pem'
    default['bamboo']['apache2']['ssl']['key_file']         = '/etc/ssl/private/ssl-cert-snakeoil.key'
end

default['bamboo']['tomcat']['keyAlias']                     = 'tomcat'
default['bamboo']['tomcat']['keystoreFile']                 = "#{node['bamboo']['home_path']}/.keystore"
default['bamboo']['tomcat']['keystorePass']                 = 'changeit'
default['bamboo']['tomcat']['port']                         = '8080'
default['bamboo']['tomcat']['ssl_port']                     = '8443'

default['bamboo']['apache2']['access_log']                  = ''
default['bamboo']['apache2']['error_log']                   = ''
default['bamboo']['apache2']['port']                        = 80
default['bamboo']['apache2']['virtual_host_alias']          = node['fqdn']
default['bamboo']['apache2']['virtual_host_name']           = node['hostname']

default['bamboo']['apache2']['ssl']['access_log']           = ''
default['bamboo']['apache2']['ssl']['chain_file']           = ''
default['bamboo']['apache2']['ssl']['error_log']            = ''
default['bamboo']['apache2']['ssl']['port']                 = 443



