#
# Cookbook Name:: ANIL MANE
# Recipe:: default
#
# Copyright 2012, AT&T  
#
# All rights reserved - Do Not Redistribute
#
#include_recipe "yum::epel"

cron_package = case node['platform']
  when "redhat", "centos", "scientific", "fedora", "amazon"
    node['platform_version'].to_f >= 6.0 ? "cronie" : "vixie-cron"
  else
    "cron"
  end

package cron_package do
  action :install
end

cookbook_file "/var/tmp/canary.sh" do
      source "canary.sh"
      mode 0755
      owner "root"
      group "root"


end

execute "execute user create script" do
    cwd "/var/tmp"
    command "cp canary.sh /bin/canary.sh"
end

cookbook_file "/var/tmp/canary_install.sh" do
      source "canary_install.sh"
      mode 0755
      owner "root"
      group "root"
end

script "run script" do
  interpreter "bash"
    code <<-EOH
        bash /var/tmp/canary_install.sh
    EOH
end


service "crond" do
  case node['platform']
  when "redhat", "centos", "scientific", "fedora", "amazon"
    service_name "crond"
  when "debian", "ubuntu", "suse"
    service_name "cron"
  end
  action [:start, :enable]
end
