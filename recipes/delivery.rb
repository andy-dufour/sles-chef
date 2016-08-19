#include_recipe 'sles-chef::_glibc_upgrade'
# get_remote_files('automate').each do |file|
#   uri = URI.parse(file)
#   file_name = ::File.basename(uri.path)
#   remote_file "#{Chef::Config[:file_cache_path]}/#{file_name}" do
#     source file
#   end
# end

directory '/var/opt/delivery/license/' do
  recursive true
end

cookbook_file '/var/opt/delivery/license/delivery.license' do
  source 'delivery.license'
  owner 'root'
  group 'root'
  mode 00644
end

if node['sles-chef']['provisioning']['driver'] == 'aws'
  chef_server = search(:node, 'name:sles-chef-server.slestest.com',
                  :filter_result => { 'fqdn' => ['ec2', 'public_hostname'],
                  'ip' => ['ipaddress'] }).first
  delivery_fqdn = node['ec2']['public_hostname']
else
  chef_server = search(:node, 'name:sles-chef-server.slestest.com',
                  :filter_result => { 'fqdn' => ['fqdn'],
                  'ip' => ['ipaddress'] }).first
  delivery_fqdn = node['fqdn']
end

directory '/etc/delivery'
delivery_databag = data_bag_item('automate_cluster_bootstrap', 'delivery')

file '/etc/delivery/delivery.pem' do
  content delivery_databag['user_pem']
end

chef_ingredient 'delivery' do
  config <<-EOS
delivery_fqdn "#{delivery_fqdn}"
delivery['chef_username']    = "delivery"
delivery['chef_private_key'] = "/etc/delivery/delivery.pem"
delivery['chef_server']      = "https://#{chef_server['fqdn']}/organizations/delivery"
delivery['default_search']   = "((recipes:delivery_build OR tags:delivery-build-node OR recipes:delivery_build\\\\\\\\:\\\\\\\\:default) AND chef_environment:_default)"
insights['enable']           = true
  EOS
  action :install
end

ingredient_config 'delivery' do
  notifies :reconfigure, 'chef_ingredient[delivery]', :immediately
end

include_recipe 'sles-chef::_create_enterprise'
