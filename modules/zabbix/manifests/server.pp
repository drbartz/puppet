class zabbix::server {
	
	package { ['iptables', 'zabbix-server', 'zabbix-web-mysql','zabbix-java-gateway']:
		ensure	=> installed,
		require	=> [
			Package['epel-release'], 
			Class['zabbix::repo'], 
		],
	}

	file {'/etc/zabbix':
		ensure 	=> directory,
	}

	file {'/etc/zabbix/web':
		ensure 	=> directory,
		require	=> File['/etc/zabbix'],
	}

	file { '/etc/httpd/conf.d/zabbix.conf':
		ensure 	=> present,
		content 	=> file('zabbix/zabbix_http_conf'),
		notify	=> Service['httpd'],
		require	=> [
			Package['httpd'],
			Package['zabbix-server'],
		],
	}

	file { '/etc/zabbix/web/zabbix.conf.php':
		ensure 	=> present,
		content 	=> file('zabbix/zabbix_conf.php'),
		notify	=> Service['httpd'],
		require	=> [
			File['/etc/zabbix/web'],
			Package['zabbix-server'],
			Package['httpd'],
		],
	}

	file {'/etc/zabbix/zabbix_server.conf':
		ensure 	=> present,
		content 	=> file('zabbix/zabbix_server.conf'),
		notify	=> Service['zabbix-server'],
		require	=> Package['zabbix-server'],
	}

	file {'/etc/zabbix/.install_zabbix_server.sh':
		ensure 	=> present,
		owner		=> "root",
		group		=> "root",
		mode		=> 755,
		content 	=> file('zabbix/install_zabbix_server.sh'),
		require	=> File['/etc/zabbix'],
	}

	exec {'Post install zabbix':
		command	=> '/etc/zabbix/.install_zabbix_server.sh',
		creates	=> '/etc/zabbix/.install_zabbix_server.done',
		require	=> [
			File['/etc/zabbix/.install_zabbix_server.sh'],
			Package['zabbix-server'],
			Package['git'],
			Service['mysqld'],
		],
	}

	service {'zabbix-server':
		ensure	=> running,
		enable	=> true,
		require	=> [
			Package['zabbix-server'],
			Exec['Post install zabbix'],
		],
	}

	file {'/etc/sysconfig/iptables':
		ensure	=> present,
		owner		=> "root",
		group		=> "root",
		mode		=> 600,
		content 	=> file('zabbix/iptables'),
		require	=> Package['iptables'],
		notify	=> Service['iptables'],
	}

	service {'iptables':
		ensure	=> running,
		enable	=> true,
		require	=> Package['iptables'],
	}

}
