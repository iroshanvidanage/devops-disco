
$nameservers = ['192.168.1.2', '192.168.2.2', '10.0.0.2']
$search = 'admin.example.com example.com'

$output = epp('template_module/search.epp', {'nameservers' => $nameservers, 'search' => $search})
