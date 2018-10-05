#
# Cookbook Name:: users
# Recipe:: groups   
#
# Searches data bag "users" for groups attribute "group".
# Places returned users in Unix group "sysadmin" with GID $$$$.


#ASG Application users 
users_manage "inter" do
  data_bag "interactions"
  group_id 3401
  action [ :remove, :create ]
end

