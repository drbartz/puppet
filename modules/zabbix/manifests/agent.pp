class zabbix::agent {

	include zabbix::repo

	#file { [ "/etc/zabbix/", "/var/log/zabbix" ]:
		#ensure	=> directory,
		#owner 	=> zabbix,
		#group 	=> zabbix,
		#mode		=> 0755,
	#}

	file { "/etc/zabbix/zabbix_agentd.conf":
		owner 	=> zabbix,
		group 	=> zabbix,
		mode		=> 0644,
		notify	=> Service['zabbix-agent'],
		require	=> [
			Class['zabbix::repo'],
			Package['zabbix-agent'],
		],
		content 	=> file('zabbix/zabbix_agent.conf'),
	}

#	file { "/etc/zabbix/zabbix_agentd.userparams.conf":
#		owner => zabbix,
#		group => zabbix,
#		mode=> 0644,
#		notify=> Service["zabbix-agent"],
#		content => template("zabbix/zabbix_agentd.userparams.erb");
#	}

#	file {"/var/run/zabbix":
#		ensure=> directory,
#		owner => zabbix,
#		group => zabbix,
#		mode=> 0775;
#	}

	#sudo::file { 'zbx': }

	service { 'zabbix-agent':
		enable=> 'true',
		hasstatus => 'true',
		hasrestart=> 'true',
		pattern => "/usr/sbin/zabbix_agentd",
		ensure=> 'running',
		require => [
			File["/etc/zabbix/zabbix_agentd.conf"], 
			Package["zabbix-agent"],
		],
	}

	package { "zabbix-agent":
		ensure=> present,
		require	=> Class['zabbix::repo'],
	}
}
