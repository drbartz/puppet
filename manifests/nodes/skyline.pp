node /skyline.*/ {
	include basic
	include puppet::client
	include redis
	include graphite::collect
}
