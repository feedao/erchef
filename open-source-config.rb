# This annotated Pedant configuration file details the various
# configuration settings available to you.  It is separate from the
# actual Pedant::Config class because not all settings have sane
# defaults, and not all settings are appropriate in all settings.

################################################################################
# You MUST specify the address of the server the API requests will be
# sent to.  Only specify protocol, hostname, and port.
chef_server "https://#{`hostname -f`.strip}"

# If you are doing development testing, you can specify the address of
# the Solr server.  The presence of this parameter will enable tests
# to force commits to Solr, greatly decreasing the amout of time
# needed for testing the search endpoint.  This is only an
# optimization for development!  If you are testing a "live" Chef
# Server, or otherwise do not have access to the Solr server from your
# testing location, you should not specify a value for this parameter.
# The tests will still run, albeit slower, as they will now need to
# poll for a period to ensure they are querying committed results.
search_server "http://localhost:8983"

# Related to the 'search_server' parameter, this specifies the maximum
# amout of time (in seconds) that search endpoint requests should be
# retried before giving up.  If not explicitly set, it will default to
# 65 seconds; only set it if you know that your Solr commit interval
# differs significantly from this.
maximum_search_time 65

# We're starting to break tests up into groups based on different
# criteria.  The proper API tests (the results of which are viewable
# to OPC customers) should be the only ones run by Pedant embedded in
# OPC installs.  There are other specs that help us keep track of API
# cruft that we want to come back and fix later; these shouldn't be
# viewable to customers, but we should be able to run them in
# development and CI environments.  If this parameter is missing or
# explicitly `false` only the customer-friendly tests will be run.
#
# This is mainly here for documentation purposes, since the
# command-line `opscode-pedant` utility ultimately determines this
# value.
include_internal false

# Test users.  The five users specified below are required; their
# names (:user, :non_org_user, etc.) are indicative of their role
# within the tests.  All users must have a ':name' key.  If they have
# a ':create_me' key, Pedant will create these users for you.  If you
# are using pre-existing users, you must supply a ':key_file' key,
# which should be the fully-qualified path /on the machine Pedant is
# running on/ to a private key for that user.

superuser_name 'chef-webui'
superuser_key  '/etc/chef-server/webui.pem'

requestors({
             :clients => {
               # The the admin user, for the purposes of getting things rolling
               :admin => {
                 :name => "pedant_admin_client",
                 :create_me => true
               },
               :non_admin => {
                 :name => 'pedant_client',
                 :create_me => true
               },
               :bad => {
                 :name => 'bad_client'
               }
             },
             :users => {
               # A user for Knife tests.  A knife.rb and key files will be set up
               # for this user
               :knife_user => {
                 :name => "knifey",
                 :create_me => true
               }
             }
           })

# To facilitate testing as we transition from Ruby to Erlang endpoint
# implementations, you can specify in your configuration which
# implementation for each endpoint is currently active on the system
# under test.  Tests should be written to fork on this value if
# necessary.  A common reason is to take into account different error
# message formatting between the two implementations.
#
ruby_environment_endpoint? true
ruby_client_endpoint? true
ruby_sandbox_endpoint? true
ruby_data_endpoint? true
ruby_role_endpoint? true
ruby_cookbook_endpoint? true
