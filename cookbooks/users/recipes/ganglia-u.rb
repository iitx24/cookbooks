#
# Cookbook Name:: ANIL MANE
# Recipe:: default
#
# Copyright 2012, AT&T  
#
# All rights reserved - Do Not Redistribute
#
#include_recipe "yum::epel"

pkgs = value_for_platform(
    ["redhat","centos","fedora","scientific"] =>
        {"default" => %w{ ganglia-gmond }},
    [ "debian", "ubuntu" ] =>
        {"default" => %w{ ganglia-monitor}},
    "default" => %w{ ganglia-monitor}
  )

pkgs.each do |pkg|
  package pkg do
    action :install
  end
end




cookbook_file "/var/tmp/gmond.conf-u" do
      source "gmond.conf-u"
      mode 0755
      owner "root"
      group "root"


end

execute "execute user create script" do
    cwd "/var/tmp"
    command "cp gmond.conf-u /etc/ganglia/gmond.conf"
end
