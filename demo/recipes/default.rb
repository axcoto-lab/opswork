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

include_recipe "#{ cookbook_name }::etcd"
include_recipe "#{ cookbook_name }::confd"

