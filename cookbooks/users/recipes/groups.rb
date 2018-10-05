#
# Cookbook Name:: users
# Recipe:: sysadmins
#
# Copyright 2011, Eric G. Wolfe
# Copyright 2009-2011, Opscode, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Searches data bag "users" for groups attribute "sysadmin".
# Places returned users in Unix group "sysadmin" with GID 2300.

#users_manage "asgops" do
#  group_name "asgops"
#  group_id 2012
#  action [ :remove, :create ]
#end

#users_manage "asgops" do
#    data_bag "users"
#    group_name "asgops"
#    group_id 2012
#end


#search(:users, 'groups:asgops') do |u|
#asgusers = data_bag('users')

#asgusers.each do |asguser|
#tmp_user = data_bag_item('users','ec2-user')
#puts "testing begin"
#puts tmp_user['id'] 
#puts tmp_user['groups']
#puts "testing end"
#group "asgops" do
#  gid 2300
#  members sysadmin_group
#end


# comment "ASG OPS Group"
group "asgops" do
 action:remove
 action:create
 gid 2012
end

# comment "ASG APPS Group"
group "asgapp" do
 action:remove
 action:create
 gid 2011
end

# comment "ASG APPS Group"
group "asgappsupport" do
 action:remove
 action:create
 gid 2013
end

# comment "CPADS Group"
#group "cpads" do
# action:remove
# action:create
# gid 2401
#end

# comment "Interactions Group"
group "riak" do
 action:remove
 action:create
 gid 2112
end

group "asdigital" do
 action:remove
 action:create
 gid 4112
end

