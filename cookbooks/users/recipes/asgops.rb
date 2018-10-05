#
# Cookbook Name:: users
# Recipe:: groups   
#
# Searches data bag "users" for groups attribute "group".
# Places returned users in Unix group "sysadmin" with GID $$$$.


#ASG System Aadmin users 
users_manage "asgops" do
  data_bag "asgops"
  group_id 2012
  action [ :remove, :create ]
end

