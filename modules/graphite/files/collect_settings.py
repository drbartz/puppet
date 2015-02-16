"""
	Dafault configuration
"""
# LOGGIN settings
LOG_FILE="/var/log/collect.log"
LOG_LEVEL="DEBUG"

# Name that will appear on Graphite tree
CLIENT_PREFIX = "srv.tools"

# time to wait for the next pooling, in secons
CLIENT_POOLING = 15

"""
Graphite Server, where your carbon is running
"""
GRAPHITE_SERVER_IP = "10.10.10.3"
GRAPHITE_SERVER_PORT = 2003

# if ocour som problem to connect with graphite server, how many retrys?
GRAPHITE_RETRY_LIMIT = 3
