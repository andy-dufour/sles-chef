require 'chef/data_bag'
require 'uri'

include_recipe 'sles-chef::_glibc_upgrade'

get_remote_files('backend').each do |file|
  uri = URI.parse(file)
  file_name = ::File.basename(uri.path)
  remote_file "#{Chef::Config[:file_cache_path]}/#{file_name}" do
    source file
  end
end

chef_ingredient 'chef-server' do
  action :install
  config <<-CONFIG
topology 'tier'
api_fqdn '#{node['sles-chef']['api-fqdn']}'

server '#{node['fqdn']}',
  :ipaddress => "#{node['ipaddress']}",
  :role => "backend",
  :bootstrap => true

backend_vip "#{node['fqdn']}",
  :ipaddress => "#{node['ipaddress']}",
  :device => "eth0"
  CONFIG
  package_source Chef::Config[:file_cache_path] + "/chef-server-core-#{node['sles-chef']['chef_server']['version']}.el6.x86_64.rpm"
end

ingredient_config "chef-server" do
  notifies :reconfigure, "chef_ingredient[chef-server]", :immediately
end

chef_ingredient 'reporting' do
  notifies :reconfigure, 'chef_ingredient[reporting]'
  package_source Chef::Config[:file_cache_path] + "/opscode-reporting-#{node['sles-chef']['reporting']['version']}.el6.x86_64.rpm"
  accept_license true
end

chef_ingredient 'push-jobs-server' do
  notifies :reconfigure, 'chef_ingredient[push-jobs-server]'
  package_source Chef::Config[:file_cache_path] + "/opscode-push-jobs-server-#{node['sles-chef']['push_server']['version']}.el6.x86_64.rpm"
end

ruby_block 'save databag' do
  block do
    pivotal_key = {'id' => 'pivotal',
                  'key' => ::File.read('/etc/opscode/pivotal.pem')}

    secrets = {'id' => 'secrets',
              'secrets' => ::File.read('/etc/opscode/private-chef-secrets.json')}


    pivotal_item = Chef::DataBagItem.new
    pivotal_item.data_bag('automate_cluster_bootstrap')
    pivotal_item.raw_data = pivotal_key
    pivotal_item.save

    secrets_item = Chef::DataBagItem.new
    secrets_item.data_bag('automate_cluster_bootstrap')
    secrets_item.raw_data = secrets
    secrets_item.save
  end
end
