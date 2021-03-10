# InSpec test for recipe jenkins::default

# The InSpec reference, with examples and extensive documentation, can be
# found at https://docs.chef.io/inspec/resources/

#unless os.windows?
  # This is an example test, replace with your own test.
 # describe user('root'), :skip do
  #  it { should exist }
 # end
#end

# This is an example test, replace it with your own test.
#describe port(80), :skip do
#  it { should_not be_listening }
#end
describe file('/root/.jenkins/secrets/initialAdminPassword') do
 it { should exist } 
end 

describe command('curl localhost:8080') do 
 its('stdout') { should match(/hudson/) } 
end 
