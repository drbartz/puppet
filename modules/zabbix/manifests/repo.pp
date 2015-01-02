class zabbix::repo {
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
}
