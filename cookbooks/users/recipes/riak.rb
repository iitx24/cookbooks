#
# Cookbook Name:: users
# Recipe:: groups   
#
# Searches data bag "users" for groups attribute "group".
# Places returned users in Unix group "sysadmin" with GID $$$$.


#ASG Application users 
users_manage "riak" do
  data_bag "riak"
  group_id 2112
  action [ :remove, :create ]
end

