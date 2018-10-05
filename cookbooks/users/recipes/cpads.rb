#
# Cookbook Name:: users
# Recipe:: groups   
#
# Searches data bag "users" for groups attribute "group".
# Places returned users in Unix group "sysadmin" with GID $$$$.


#ASG Application users 
users_manage "cpads" do
  data_bag "cpads"
  group_id 2401
  action [ :remove, :create ]
end

