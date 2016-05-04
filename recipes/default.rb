version = node['dotnetframework']['version']

dotnet4dir = File.join(ENV['WINDIR'], 'Microsoft.Net\\Framework64\\v4.0.30319')
node.set['dotnetframework']['dir'] = dotnet4dir

windows_task 'chef-client on startup for VS' do
  user node['windows-cluster']['user-name']
  password pass.strip
  command "cmd /C chef-client -o recipe[visualstudio]"
  run_level :highest
  frequency :onstart
end

windows_reboot 60 do
  reason 'dotnetframework requires a reboot to complete'
  action :nothing
end

dotnetframework_version node['dotnetframework'][version]['version'] do
  source node['dotnetframework'][version]['url']
  package_name node['dotnetframework'][version]['package_name']
  checksum node['dotnetframework'][version]['checksum']
  notifies :request, 'windows_reboot[60]', :immediately
end
