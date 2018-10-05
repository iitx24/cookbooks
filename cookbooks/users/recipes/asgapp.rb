#
# Cookbook Name:: users
# Recipe:: groups   
#
# Searches data bag "users" for groups attribute "group".
# Places returned users in Unix group "sysadmin" with GID $$$$.


#ASG Application users 
users_manage "asgapp" do
  data_bag "asgapps"
  group_id 2011
  action [ :remove, :create ]
end

