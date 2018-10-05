#
# Cookbook Name:: users
# Recipe:: groups   
#
# Searches data bag "users" for groups attribute "group".
# Places returned users in Unix group "sysadmin" with GID $$$$.


#ASG Application Support users
users_manage "asgappsupport" do
  data_bag "asgappsupport"
  group_id 2013
  action [ :remove, :create ]
end
