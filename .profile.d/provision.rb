require 'json'

vcap = ENV['VCAP_SERVICES']
data = JSON.parse(vcap)
creds = data['objectstorage'][0]['credentials']
auth_uri = creds['auth_uri']
user = creds['username']
pass = creds['password']

`curl -s -I --user #{user}:#{pass} #{auth_uri}/WordPress`

puts 'Provision request sent...'
