node /graphite.*[0-9][0-9]$/ {
	#package { [ 'epel-release', 'graphite-web', 'python-carbon']:
	#	ensure => installed,
	#}
	include basic
	include puppet::client
	include graphite
}
