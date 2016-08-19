require 'net/ssh'

builder_key = OpenSSL::PKey::RSA.new(2048)

file '/etc/delivery/builder_key' do
  content builder_key.to_pem
  owner 'root'
  group 'root'
  mode 0400
  action :create
  not_if { ::File.exists?('/etc/delivery/builder_key') }
end

file '/etc/delivery/builder_key.pub' do
  content "ssh-rsa #{[builder_key.to_blob].pack('m0')}"
  owner 'root'
  group 'root'
  mode 0644
  action :create
  not_if { ::File.exists?('/etc/delivery/builder_key.pub') }
end

execute 'create delivery enterprise' do
  command 'delivery-ctl create-enterprise delivery --ssh-pub-key-file=/etc/delivery/builder_key.pub > /etc/delivery/admin.creds'
  not_if 'delivery-ctl list-enterprises --ssh-pub-key-file=/etc/delivery/builder_key.pub | grep -w delivery'
end

execute 'create delivery user' do
  command 'delivery-ctl create-user delivery delivery > /etc/delivery/delivery.creds'
  not_if 'delivery-ctl list-users delivery | grep -w delivery'
end

ruby_block 'save build databag' do
  block do
    build_node = {'id' => 'build_node',
              'build_node_private_key' => ::File.read('/etc/delivery/builder_key'),
              'build_node_public_key' => ::File.read('/etc/delivery/builder_key.pub')}

    build_item = Chef::DataBagItem.new
    build_item.data_bag('automate_cluster_bootstrap')
    build_item.raw_data = build_node
    build_item.save
  end
end
