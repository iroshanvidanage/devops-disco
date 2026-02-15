
Puppet::Functions.create_function(:'hostname::environment') do
  dispatch :environment do
    param 'String', :server_name
  end

  def environment(server_name)
    ...
  end
end