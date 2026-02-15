
# puppet function

function mymodule::sayhello(String $name) >> String {
  $greeting = "Hello, ${name}!"
  $greeting # The last value to get evaluated is returned implicitly
}
