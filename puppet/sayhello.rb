
# ruby functions
# function path: <modulepath>/mymodule/lib/puppet/functions/mymodule/sayhello.rb
Puppet::Functions.create_function(:'mymodule::sayhello') do
  # dispatch block defines the parameters and their types for the function
  dispatch :sayhello do
    param 'String', :name
  end
  
  # the actual implementation of the function
  def sayhello(name)
    return "Hello, #{name}!"
  end
end