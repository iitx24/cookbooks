#
# Cookbook Name:: User creation script
# Recipe:: default
#
# Copyright 2012, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

  cookbook_file "/var/tmp/add_users.tar.gz" do
      source "add_users.tar.gz"
      mode 0755
      owner "root"
      group "root"

      
  end

  execute "execute user create script" do
    cwd "/var/tmp"
    command "tar xvf add_users.tar.gz -C /var/tmp"
  end

  script "run script" do
  interpreter "bash"
    code <<-EOH
	bash /var/tmp/add_user_apps.sh
	bash /var/tmp/add_user_ops.sh
	bash /var/tmp/isec.sh
    EOH
  end
