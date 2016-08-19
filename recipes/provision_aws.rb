include_recipe 'chef-provisioning-aws-helper::default'

machine 'sles-chef-server' do
  recipe 'sles-chef::chef-server'
  machine_options aws_options('sles-chef-server')
  action :converge
end

machine 'sles-automate-server' do
  recipe 'sles-chef::delivery'
  machine_options aws_options('sles-automate-server')
  action :converge
end


# node['sles-chef']['nodes'].each do |vmname|
#   machine "sles-cluster-#{vmname}" do
# end
