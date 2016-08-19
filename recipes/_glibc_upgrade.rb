
cookbook_file '/tmp/glibc-2.14.1-14.12.5.x86_64.rpm' do
  source 'glibc-2.14.1-14.12.5.x86_64.rpm'
  owner 'root'
  group 'root'
  mode 00644
end


rpm_package '/tmp/glibc-2.14.1-14.12.5.x86_64.rpm' do
  action :install
  options '--nodeps'
end
