task :default => [:up]

desc 'Bring up the chef cluster (default)'
task :up => :setup do
  sh('chef-client -z -o sles-chef::provision')
end

desc 'Destroy the chef cluster'
task :destroy do
  sh('chef-client -z -o sles-chef::destroy')
end
task :cleanup => :destroy

desc 'Chef setup tasks'
task :setup do
  if Dir.exist?('vendor')
    sh('berks update --quiet')
    sh('rm -rf vendor/*')
  else
    sh('berks install --quiet')
    Dir.mkdir('vendor')
  end
  sh('berks vendor vendor/ --quiet')
end
