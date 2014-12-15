node 'puppet' {
	include basic
	include puppet::client
	#include puppet::server
}
