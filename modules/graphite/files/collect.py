#!/usr/bin/env python
import platform
import socket
import psutil
import sys
from settings import *
from time import time, sleep
import logging as log

try: LOG_FILE
except: LOG_FILE="/var/log/collect.log"

try:
	log.basicConfig(filename=LOG_FILE,level=log.DEBUG)
except:
	sys.exit("FATAL: Can't write to log file: "+LOG_FILE +"\n\nPelase check instructions on README.md file" )

class Collect:
	def __init__(self):
		"""
		default settins came from settins.py
		"""
		self.conf = {}
# last value
		self.last = {}
# calculate value to send to graphite
		self.final = []
		self.retrycount=0
		hostname = socket.gethostname()
		try: self.conf["CLIENT_PREFIX"]=CLIENT_PREFIX
		except: self.conf["CLIENT_PREFIX"]="srv.client"
		self.conf["CLIENT_PREFIX"]=self.conf["CLIENT_PREFIX"]+"."+str(hostname).split(".")[0]
	
		try: self.conf["GRAPHITE_SERVER_IP"]=GRAPHITE_SERVER_IP
		except: self.conf["GRAPHITE_SERVER_IP"]="127.0.0.1"
		
		try: self.conf["GRAPHITE_SERVER_PORT"]=GRAPHITE_SERVER_PORT
		except: self.conf["GRAPHITE_SERVER_PORT"]=2003

		try: self.conf["GRAPHITE_RETRY_LIMIT"]=GRAPHITE_RETRY_LIMIT
		except: self.conf["GRAPHITE_RETRY_LIMIT"]=3

		try: self.conf["CLIENT_POOLING"]=CLIENT_POOLING
		except: self.conf["CLIENT_POOLING"]=60

	def add_data(self,name,data,type='GAUGE'):
		"""
      appends data to the current database to be written.

		type values = 'GAUGE' or 'COUNTER', where 
			'GAUGE' is for things like %CPU, total memory. In this case, collect will send the last value
			'COUNTER' is for continus increment, like ifInOctets. In this case, collect will send only de difference between this value and the last one
		"""
		nowtime=int(time())
		if type=='GAUGE':
			self.final.append({"name":name,"data":data,"time":nowtime,"type":type})
		if type=='COUNTER':
			# Check if there is a last valid value
			if name in self.last:
				if ( nowtime - self.last[name]["time"]) < ( 2 * self.conf["CLIENT_POOLING"]):
					delta_data = data - self.last[name]["data"]
					delta_time = nowtime - self.last[name]["time"]
					final_data = delta_data/delta_time
					self.final.append({"name":name,"data":final_data,"time":nowtime,"type":type})
				else: log.debug("no valid last data for: "+ name+" on time"+str( 2 * self.conf["CLIENT_POOLING"]))
			else: log.debug("no last data for: "+ name)
			# Add to last db the last value
			if name not in self.last: self.last[name]={ "data":0, "time":0 }
			self.last[name]["data"]=data
			self.last[name]["time"]=nowtime

	def collect_disk_io(self,whitelist=[]):
		"""
		disks is a list of disk to be collected
		if disks is empty, collect all disk io stats
		"""
		stats=psutil.disk_io_counters(perdisk=True)
		for entry,stat in stats.iteritems():
			if not whitelist or entry in whitelist:
				for k,v in stat._asdict().iteritems():
					self.add_data("so.disk.%s.%s"%(entry,k),v,type='COUNTER')

	def collect_network_io(self,whitelist=[]):
		"""
		collect_network_io is a list of disk to be collected
		"""
		stats=psutil.net_io_counters(pernic=True)
		for entry,stat in stats.iteritems():
			if not whitelist or entry in whitelist:
				for k,v in stat._asdict().iteritems():
					self.add_data("so.nic.%s.%s"%(entry.replace(" ","_"),k),v,type='COUNTER')
	def collect_cpu_times(self,whitelist=[]):
		"""
		whitelist is a list of cpus to be used, must be integer
		"""
		stats=psutil.cpu_times(percpu=True)
		for entry,stat in enumerate(stats):
			if not whitelist or entry in whitelist:
				for k,v in stat._asdict().iteritems():
					self.add_data("so.cpu.%d.%s"%(entry,k),v,type='COUNTER')
	def collect_phymem_usage(self):
		"""
		collect_phymem_usage is a list of pysical memory to be collected
		"""
		#stats = psutil.phymem_usage()
		stats = psutil.virtual_memory()
		for k,v in stats._asdict().iteritems():
			self.add_data("so.phymem.%s"%k,v)

	def collect_uptime(self):
		"""
		collect_uptime is a the machine uptime
		"""
		uptime = int(time()) - int(psutil.boot_time())
		self.add_data("so.uptime",uptime)

	def collect_virtmem_usage(self):
		"""
		collect_virtmem_usage is a list of virtual memory to be collected
		"""
		stats = psutil.swap_memory()
		for k,v in stats._asdict().iteritems():
			self.add_data("so.virtmem.%s"%k,v)

	def collect_disk_usage(self,whitelist=[]):
		"""
		for free disk whitelist, both mountpoint (`/`) and device (`/dev/sda1`)
		is fine.
		Sys-fs will be ignored by default

		TODO implement the ability to get free Disk space for sysfs etc
		"""
		for partition in psutil.disk_partitions():
			if not whitelist or partition.mountpoint in whitelist or partition.device in whitelist :
				usage = psutil.disk_usage(partition.mountpoint)
				if platform.system() == "Windows"  :
					disk_name = "-"+partition.mountpoint.replace("\\","").replace(":","") 
				else:
					disk_name=partition.mountpoint.replace("/","-")
					if disk_name == "-":
						disk_name="-root"
				self.add_data("so.volume.%s.total"%
					disk_name, usage.total)
				self.add_data("so.volume.%s.used"%
					disk_name, usage.used)
				self.add_data("so.volume.%s.free"%
					disk_name, usage.free)
 
	def connect_graphite(self):
		self.sock = socket.socket()
		if self.retrycount >= self.conf["GRAPHITE_RETRY_LIMIT"]:
			msg="retry exceed trying connecting to %s:%d"%(IP,PORT)
			log.critical(msg)
			sys.exit(msg)
		IP=self.conf["GRAPHITE_SERVER_IP"]
		PORT=self.conf["GRAPHITE_SERVER_PORT"]
		try:
			self.sock.connect((IP,PORT))
			log.debug("connecting to %s:%d"%(IP,PORT))
		except:
			log.critical("Error connecting to %s:%d"%(IP,PORT))
			self.retrycount+=1

	def _write_graphite_msg(self,db):
		"""
		db is the object to be written into the buffer
		"""
		msg = ""
		for e in self.final:
			line = "%s.%s %s %s\r\n" %(self.conf["CLIENT_PREFIX"],e["name"],e["data"],e["time"])
			msg=msg + line
		return msg
        
	def send_graphite(self):
		"""
		write the collected entries to the graphite server
		"""
		msg = self._write_graphite_msg(self)
		tries = 1
		while msg and tries <= self.conf["GRAPHITE_RETRY_LIMIT"]:
			try:
				l = self.sock.send(msg)
				msg = msg[l:]
				log.debug("finish sending message")
			except: 
				log.error("Cannot send message, reconnecting...")

			try:
				self.connect_graphite()
			except:
				log.error("Cannot connect to host, retrying (%d/%d)"
					%(tries,self.conf["GRAPHITE_RETRY_LIMIT"]))
				tries+=1

	def close_graphite(self):
		self.sock.close()

	def clean_db(self):
		"""
		reset the database, needs to be done after every to_x
		"""
		del (self.final)
		self.final = []

	def collect_all(self):
		"""
		TODO automagically find functions for collector
		TODO add whitelisting feature in some cool way
		"""
		self.collect_disk_io()
		self.collect_cpu_times()
		self.collect_uptime()
		self.collect_network_io()
		self.collect_phymem_usage()
		self.collect_virtmem_usage()
		self.collect_disk_usage()

if __name__ == "__main__":
	a = Collect()
	while 1==1:
		a.connect_graphite()
		a.collect_all()
		a.send_graphite()
		a.close_graphite()
		a.clean_db()
		sleep(a.conf["CLIENT_POOLING"])	
