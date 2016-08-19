require 'chef/data_bag'
require 'uri'

#include_recipe 'sles-chef::_glibc_upgrade'

# get_remote_files('server').each do |file|
#   uri = URI.parse(file)
#   file_name = ::File.basename(uri.path)
#   remote_file "#{Chef::Config[:file_cache_path]}/#{file_name}" do
#     source file
#   end
# end

if node['sles-chef']['provisioning']['driver'] == 'aws'
  chef_server_fqdn = node['ec2']['public_hostname']
else
  chef_server_fqdn = node['fqdn']
end

chef_ingredient 'chef-server' do
  action :install
  config <<-CONFIG
topology 'standalone'
api_fqdn '#{chef_server_fqdn}'
  CONFIG
end

ingredient_config "chef-server" do
  notifies :reconfigure, "chef_ingredient[chef-server]", :immediately
end

include_recipe 'sles-chef::_manage'
include_recipe 'sles-chef::_reporting'
include_recipe 'sles-chef::_push_server'
include_recipe 'sles-chef::_chef_delivery_org_setup'

ruby_block 'save databag' do
  block do
    pivotal_key = {'id' => 'pivotal',
                  'key' => ::File.read('/etc/opscode/pivotal.pem')}

    secrets = {'id' => 'secrets',
              'secrets' => ::File.read('/etc/opscode/private-chef-secrets.json')}

    delivery = {'id' => 'delivery',
              'validator_pem' => ::File.read('/tmp/delivery-validator.pem'),
              'user_pem' => ::File.read('/tmp/delivery.pem')}

    pivotal_item = Chef::DataBagItem.new
    pivotal_item.data_bag('automate_cluster_bootstrap')
    pivotal_item.raw_data = pivotal_key
    pivotal_item.save

    secrets_item = Chef::DataBagItem.new
    secrets_item.data_bag('automate_cluster_bootstrap')
    secrets_item.raw_data = secrets
    secrets_item.save

    delivery_item = Chef::DataBagItem.new
    delivery_item.data_bag('automate_cluster_bootstrap')
    delivery_item.raw_data = delivery
    delivery_item.save
  end
end
