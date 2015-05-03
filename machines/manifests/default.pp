class { 'elasticsearch':
  package_url => 'https://download.elastic.co/elasticsearch/elasticsearch/elasticsearch-1.5.2.noarch.rpm',
  config => { 
    'cluster.name' => 'boink', 
    'network' => { 
      'host' => "$ipaddress_enp0s8"
    },
    'discovery.zen.ping.multicast.enabled' => false,
    'discovery.zen.ping.unicast.hosts' => '["colon.boink.io","vimes.boink.io"]',
  },
}

elasticsearch::instance { 'es-01': }