require 'chef/data_bag'

get_remote_files('frontend').each do |file|
  remote_file file
end

directory '/etc/opscode'
data_bag('automate_cluster_bootstrap')

file '/etc/opscode/pivotal.pem' do
  content data_bag_item('automate_cluster_bootstrap', 'pivotal')
end

file '/etc/opscode/private-chef-secrets.json' do
  content data_bag_item('automate_cluster_bootstrap', 'secrets')
end

backend_server = search(:node, 'name:sles-backend*',
                        :filter_result => { 'ip' => ['ipaddress'],
                                            'fqdn' => ['fqdn']
                                          }
                        ).first

chef_ingredient 'chef-server' do
  action :install
  config <<-CONFIG
    topology 'tier'
    api_fqdn '#{node['sles-chef']['api-fqdn']}'

    server '#{node['fqdn']}',
      :ipaddress => "#{node['ipaddress']}",
      :role => 'frontend'

    server '#{backend_server['fqdn']}',
      :ipaddress => "#{backend_server['ip']}",
      :role => "backend",
      :bootstrap => true

    backend_vip "#{backend_server['fqdn']}",
      :ipaddress => "#{backend_server['ip']}",
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

chef_ingredient 'manage' do
  notifies :reconfigure, 'chef_ingredient[manage]'
  package_source Chef::Config[:file_cache_path] + "/chef-manage-#{node['sles-chef']['manage']['version']}.el6.x86_64.rpm"
  accept_license true
end
