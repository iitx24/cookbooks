#
# Cookbook Name:: User creation script
# Recipe:: default
#
# Copyright 2012, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

  cookbook_file "/var/tmp/agent.conf" do
      source "agent.conf"
      mode 0755
      owner "root"
      group "root"

      
  end

 cookbook_file "/var/tmp/logstash-shipper" do
      source "logstash-shipper"
      mode 0755
      owner "root"
      group "root"


  end

 cookbook_file "/var/tmp/logstash.sh" do
      source "logstash.sh"
      mode 0755
      owner "root"
      group "root"


  end

script "run script" do
  interpreter "bash"
    code <<-EOH
	bash /var/tmp/logstash.sh
    EOH
  end
