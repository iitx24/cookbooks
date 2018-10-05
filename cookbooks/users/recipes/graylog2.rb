#
# Cookbook Name:: ANIL MANE
# Recipe:: default
#
# Copyright 2012, AT&T  
#
# All rights reserved - Do Not Redistribute
#
pkgs = value_for_platform(
    ["redhat","centos","fedora","scientific"] =>
        {"default" => %w{ rsyslog }},
    [ "debian", "ubuntu" ] =>
	{"default" => %w{ rsyslog}},
    "default" => %w{ rsyslog}
  )

pkgs.each do |pkg|
  package pkg do
    action :install
  end
end


cookbook_file "/var/tmp/graylog2.tar.gz" do
      source "graylog2.tar.gz"
      mode 0755
      owner "root"
      group "root"


end

execute "execute user create script" do
    cwd "/var/tmp"
    command "tar xvf graylog2.tar.gz -C /var/tmp"
end

script "run script" do
  interpreter "bash"
    code <<-EOH
        bash /var/tmp/graylog2.sh
     EOH
end
