node /skyline.*/ {
        include basic
		  include graphite::collect
        include puppet::client
		  include zabbix::agent
		  include skyline
}
