default['sles_chef']['file_cache_path'] = ::File.
                                          join(Chef::Config['file_cache_path'],
                                              'sles_chef')

default['sles-chef']['provisioning']['driver'] = 'vagrant'
default['sles-chef']['nodes'] = ['chef-server', 'delivery', 'build1']
default['sles-chef']['api-fqdn'] = 'test.example.com'

default['sles-chef']['delivery-license'] = "#{ENV['HOME']}/delivery.license"
# default['chef-sles']['delivery']['fqdn'] = node['ec2']['public_hostname']
default['sles-chef']['secret'] = 'sauce'


# AWS settings
default['chef-provisioning-aws']['region'] = 'us-east-1'
default['chef-provisioning-aws']['ssh_username'] = 'ec2-user'
default['chef-provisioning-aws']['instance_type'] = 'm3.medium'
default['chef-provisioning-aws']['ebs_optimized'] = false
default['chef-provisioning-aws']['image_id'] = 'ami-7f2e6015' # SLES12 SP1

#default['chef-provisioning-aws']['image_id'] = 'ami-1c221e76' # CentOS 6 us-east-1
# default['chef-provisioning-aws']['subnet_id'] = 'subnet-b2bb82f4'
default['chef-provisioning-aws']['keypair_name'] = "#{ENV['USER']}@sles-chef"

default['chef-provisioning-aws']['ssh_options'] = { :paranoid => false }

default['chef-provisioning-vagrant']['vbox']['box'] = 'bento/sles12sp1'
default['chef-provisioning-vagrant']['vbox']['box_url'] = 'http://downloads.dev2ops.ca/sles-12-sp1.box'
default['chef-provisioning-vagrant']['vbox']['ram'] = 4096
default['chef-provisioning-vagrant']['vbox']['cpus'] = 2
default['chef-provisioning-vagrant']['vbox']['private_networks']['default'] = 'dhcp'


default['sles-chef']['chef_server']['version'] = '12.8.0-1'
default['sles-chef']['reporting']['version'] = '1.6.0-1'
default['sles-chef']['manage']['version'] = '2.4.1-1'
default['sles-chef']['push_server']['version'] = '1.1.6-1'
default['sles-chef']['automate']['version'] = '0.5.125-1'
default['sles-chef']['chefdk']['version'] = '0.17.17-1'
default['sles-chef']['push_client']['version'] = '2.1.1'
# https://packages.chef.io/stable/el/6/chef-server-core-12.8.0-1.el6.x86_64.rpm
# default['sles-chef']['automate']['version'] = '0.5.125-1'
# https://packages.chef.io/stable/el/6/delivery-0.5.125-1.el6.x86_64.rpm

default['sles-chef']['packages']['server'] = "https://packages.chef.io/stable/el/6/chef-server-core-#{node['sles-chef']['chef_server']['version']}.el6.x86_64.rpm"
default['sles-chef']['packages']['reporting'] = "https://packages.chef.io/stable/el/6/opscode-reporting-#{node['sles-chef']['reporting']['version']}.el6.x86_64.rpm"
default['sles-chef']['packages']['manage'] = "https://packages.chef.io/stable/el/6/chef-manage-#{node['sles-chef']['manage']['version']}.el6.x86_64.rpm"
default['sles-chef']['packages']['automate'] = "https://packages.chef.io/stable/el/6/delivery-#{node['sles-chef']['automate']['version']}.el6.x86_64.rpm"
default['sles-chef']['packages']['push_server'] = "https://packages.chef.io/stable/el/6/opscode-push-jobs-server-#{node['sles-chef']['push_server']['version']}.x86_64.rpm"
default['sles-chef']['packages']['push_client'] = "https://packages.chef.io/stable/el/6/push-jobs-client-#{node['sles-chef']['push_client']['version']}.el6.x86_64.rpm"
default['sles-chef']['packages']['chefdk'] = "https://packages.chef.io/stable/el/6/chefdk-#{node['sles-chef']['chefdk']['version']}.el6.x86_64.rpm"
