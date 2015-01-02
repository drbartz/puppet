class zabbix::server {

	file { '/etc/pki/rpm-gpg/RPM-GPG-KEY-ZABBIX' :
		ensure		=> present,
		content	=> file('zabbix/RPM-GPG-KEY-ZABBIX'),
		owner		=> "root",
		group		=> "root",
		mode		=> 644,
	}

	file { '/etc/yum.repos.d/zabbix.repo' :
		ensure		=> present,
		content	=> file('zabbix/zabbix.repo'),
		owner		=> "root",
		group		=> "root",
		mode		=> 644,
	}

	package { ['epel-release', 'iptables']:
		ensure	=> installed,
	}

	package { ['zabbix-server', 'zabbix-web-mysql','zabbix-java-gateway']:
		ensure	=> installed,
		require	=> [
			File['/etc/pki/rpm-gpg/RPM-GPG-KEY-ZABBIX'],
			File['/etc/yum.repos.d/zabbix.repo'],
			Package['epel-release'], 
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
		require	=> Package['httpd'],
	}

	file { '/etc/zabbix/web/zabbix.conf.php':
		ensure 	=> present,
		content 	=> file('zabbix/zabbix_conf.php'),
		notify	=> Service['zabbix-server'],
		require	=> File['/etc/zabbix/web'],
	}

	file {'/etc/zabbix/zabbix_server.conf':
		ensure 	=> present,
		content 	=> file('zabbix/zabbix_server.conf'),
		notify	=> Service['zabbix-server'],
		require	=> File['/etc/zabbix'],
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
		require	=> File['/etc/zabbix/.install_zabbix_server.sh'],
	}

	service {'zabbix-server':
		ensure	=> running,
		enable	=> true,
		require	=> Exec['Post install zabbix'],
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
