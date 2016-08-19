def get_node_runlist(vmname)
  case vmname
  when 'delivery'
    machine_runlist = 'sles-chef::delivery'
  when /^build[0-9]/
    machine_runlist = 'sles-chef::build'
  when 'chef-server'
    machine_runlist = 'sles-chef::chef-server'
  else
    raise "I don't know what to do with #{vmname}"
  end
  machine_runlist
end

# node['sles-chef']['packages']['server'] = 'https://packages.chef.io/stable/el/6/chef-server-core-12.8.0.el6.x86_64.rpm'
# node['sles-chef']['packages']['reporting'] = 'https://packages.chef.io/stable/el/6/opscode-reporting-1.6.0-1.el6.x86_64.rpm'
# node['sles-chef']['packages']['manage'] = 'https://packages.chef.io/stable/el/6/chef-manage-2.4.1-1.el6.x86_64.rpm'
# node['sles-chef']['packages']['automate'] = 'https://packages.chef.io/stable/el/6/delivery-0.5.1-1.el6.x86_64.rpm'
# node['sles-chef']['packages']['push_server'] = 'https://packages.chef.io/stable/el/6/opscode-push-jobs-server-1.1.6-1.x86_64.rpm'
# node['sles-chef']['packages']['push_client'] = 'https://packages.chef.io/stable/el/6/push-jobs-client-2.1.0-1.el6.x86_64.rpm'
# node['sles-chef']['packages']['chefdk']

def get_remote_files(product)
  packages = node['sles-chef']['packages']
  case product
  when 'server'
    downloads = [packages['server'], packages['reporting'], packages['manage'],
                packages['push_server']]
  when 'frontend'
    downloads = [packages['server'], packages['reporting'], packages['manage']]
  when 'backend'
    downloads = [packages['server'], packages['reporting'], packages['push_server']]
  when 'automate'
    downloads = [packages['automate'], packages['chefdk']]
  when 'build'
    downloads = [packages['push_client'], packages['chefdk']]
  else
    raise "I don't know what to do with product: #{product}"
  end
  downloads
end
