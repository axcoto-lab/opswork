#
# Cookbook Name:: demo
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

#execute "apt-get-update" do
#  command "apt-get update"
#  ignore_failure true
#  action :nothing
#end
install_path = "/usr/local/bin/etcd"

remote_file "#{Chef::Config[:file_cache_path]}/etcd-v2.2.4-linux-amd64.tar.gz" do
  source 'https://github.com/coreos/etcd/releases/download/v2.2.4/etcd-v2.2.4-linux-amd64.tar.gz'
  #@TODO checksum
  #checksum
  owner 'root'
  group 'root'
  mode '0755'
  not_if { ::File.exists?(install_path) }
end

bash 'extract-etcd' do
  cwd Chef::Config[:file_cache_path]
  code <<-EOF
    tar -xvf etcd-v2.2.4-linux-amd64.tar.gz
    cp etcd-v2.2.4-linux-amd64/etcd /usr/local/bin/etcd
  EOF
  not_if { ::File.exists?(install_path) }
end

# Create upstart script

#service 'apache2' do
#  supports :status => true
#  action [:enable, :start]
#end

template '/etc/init/etcd.conf' do
  source 'etcd.upstart.erb'
end

service 'etcd' do
  supports :status => true
  action [:enable, :start]
end

remote_file '/tmp/rds-cert' do
  source 'http://s3.amazonaws.com/rds-downloads/rds-combined-ca-bundle.pem'
  action :create
end

cert = `curl -sL http://s3.amazonaws.com/rds-downloads/rds-combined-ca-bundle.pem`
http_request 'write cert to etcd' do
  action :put
  url 'http://127.0.0.1:2379/v2/keys/foo'
  message "value=#{cert}"
end
