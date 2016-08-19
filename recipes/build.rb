remote_file '/tmp/chefdk.rpm' do
  source 'https://packages.chef.io/stable/el/6/chefdk-0.16.28-1.el6.x86_64.rpm'
end

rpm_package 'chef-dk' do
  action :install
  source '/tmp/chefdk.rpm'
end
