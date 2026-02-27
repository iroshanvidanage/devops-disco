
$message = lookup('greeting', String)

notify { "The greeting is: ${message}": }
