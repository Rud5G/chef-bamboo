# Roles are empty containers for equaly named recipes.
# Why? Because roles are not in a versioning system.

# http://dougireton.com/blog/2013/02/16/chef-cookbook-anti-patterns/



HOWTO Create roles:

knife role from file roles/servernode.rb
knife role from file roles/base.rb


