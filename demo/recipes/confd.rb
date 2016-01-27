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

# Download and configure confd
remote_file "/usr/local/bin/confd" do
  source 'https://github.com/kelseyhightower/confd/releases/download/v0.11.0/confd-0.11.0-linux-amd64'
  #@TODO checksum
  #checksum
  owner 'root'
  group 'root'
  mode '0755'
end
