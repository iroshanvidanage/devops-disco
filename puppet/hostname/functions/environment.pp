
functions hostname::environment(String $hostname) >> String {
  
  $env = $hostname ? {
    /[^\-]+-p-[^\-]+/ => 'Production',
    /[^\-]+-s-[^\-]+/ => 'Staging',
    /[^\-]+-d-[^\-]+/ => 'Development',
    /[^\-]+-t-[^\-]+/ => 'Testing',
    /[^\-]+-q-[^\-]+/ => 'QA',
    default => 'unknown',
  }

  $env
}
