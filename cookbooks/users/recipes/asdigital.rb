#
# Cookbook Name:: users
# Recipe:: groups   
#
# Searches data bag "users" for groups attribute "group".
# Places returned users in Unix group "sysadmin" with GID $$$$.


#ASG Application users 
users_manage "asdigital" do
  data_bag "asdigital"
  group_id 4011
  action [ :remove, :create ]
end

