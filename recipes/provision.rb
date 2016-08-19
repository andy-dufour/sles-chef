require 'chef/data_bag'

include_recipe "sles-chef::provision_#{node['sles-chef']['provisioning']['driver']}"
