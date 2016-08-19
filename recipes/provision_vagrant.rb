include_recipe 'chef-provisioning-vagrant-helper::default'

machine 'sles-chef-server.slestest.com' do
  recipe 'sles-chef::chef-server'
  machine_options vagrant_options('sles-chef-server')
  action :converge
end

machine 'sles-automate-server.slestest.com' do
  recipe 'sles-chef::delivery'
  machine_options vagrant_options('sles-automate-server')
  action :converge
end
