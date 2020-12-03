# vim: set ts=8 sts=8 sw=8 tw=0 noet:

import time
import threading

import CSRBvfsAPI
from CSRBprotocolMessage import *

import socket
import hashlib
fqdn = socket.getfqdn()
print("FQDN: %s" % fqdn)
fqdnhash = hashlib.md5()
fqdnhash.update(fqdn.encode("utf-8"))
nodeid = fqdnhash.hexdigest().upper().encode("utf-8")
print("NODEID: %s" % nodeid)

CSRBvfsAPI.libraryLoad()
CSRBvfsHandle = CSRBvfsAPI.init(
	nodeid = nodeid,
	bindHost = b"0.0.0.0",
	bindPort = 0,
	routerHost = b"public.csrb.app",
	routerPort = 32450,
	routerInterspaceUSEC = 0,
	nodeCAcertificateFile = b"../CERTS/CA.nodes.csrb.crt",
	nodeCertificateFile = b"../CERTS/C9BAD58F23D5A6C095C0571512CD318D.nodes.csrb.pem",
	vfsSectorSize = 32768,
	vfsCommandTimeoutMS = 3301,
	vfsCommandTimeoutRetries = int((500 * 1000) / 3301),
	storagePath = b"/tmp/CSRBSTORAGE")

print("CSRBvfsHandle: ", hex(CSRBvfsHandle.value))

time.sleep(1)

################################################################################
# LIST THE VIRTUAL FILESYSTEM

entries = []
CSRBvfsAPI.ls(CSRBvfsHandle, "/", entries)
print(entries)
CSRBvfsAPI.ls(CSRBvfsHandle, "/OBJECT/", entries)
print(entries)
CSRBvfsAPI.ls(CSRBvfsHandle, "/MESSAGE/", entries)
print(entries)

################################################################################
# OBJECT WRITE/READ

# OPEN TWO FILE DESCRIPTORS THE SAME OBJECT

fdOBJ1 = CSRBvfsAPI.open(CSRBvfsHandle,
	"/OBJECT/00000000000000000000000000000000/00000000000000000000000000000010")
print("OBJECT fdOBJ1: %x" % fdOBJ1)

fdOBJ2 = CSRBvfsAPI.open(CSRBvfsHandle,
	"/OBJECT/00000000000000000000000000000000/00000000000000000000000000000010")
print("OBJECT fdOBJ2: %x" % fdOBJ2)

# WRITE SOMETHING TO THE OBJECT VIA THE FIRST DESCRIPTOR

buf = b"ASDASDASDQWE!DFDFGADFGA"

print(buf)
ret = CSRBvfsAPI.write(CSRBvfsHandle,
	"/OBJECT/00000000000000000000000000000000/00000000000000000000000000000010",
	fdOBJ1,
	buf,
	len(buf),
	0)
print("wrote: %d" % ret)

# READ THE WRITTEN DATA FROM THE OBJECT VIA THE SECOND DESCRIPTOR

buf = bytearray()

ret = CSRBvfsAPI.read(CSRBvfsHandle,
	"/OBJECT/00000000000000000000000000000000/00000000000000000000000000000010",
	fdOBJ2,
	buf,
	512,
	0)
print("read: %d" % ret)
print(buf)

################################################################################
# MESSAGE SEND/RECEIVE

# OPEN TWO CHANNELS TO THE SAME MESSAGE ADDRESS

fdMSG1 = CSRBvfsAPI.open(CSRBvfsHandle,
	"/MESSAGE/00000000000000000000000000000000/0000000000000010")
print("MESSAGE fdMSG1: %x" % fdMSG1)

fdMSG2 = CSRBvfsAPI.open(CSRBvfsHandle,
	"/MESSAGE/00000000000000000000000000000000/0000000000000010")
print("MESSAGE fdMSG2: %x" % fdMSG2)

# START A THREAD TO RECEIVE MESSAGES FROM THE FIRST CHANNEL

def threadMSGrx():
	print("threadMSGrx START")
	while True:
		m = CSRBvfsAPI.CSRBmessageReceive(CSRBvfsHandle,
			"/MESSAGE/00000000000000000000000000000000/0000000000000010",
			fdMSG1)
		print(m)
	print("threadMSGrx END")

threading.Thread(target=threadMSGrx).start()

time.sleep(1)

# SEND A MESSAGE VIA THE SECOND CHANNEL

msg = CSRBprotocolMessage()
msg.header.type = 333
msg.header.params[0].id.fromHexString(nodeid)
msg.header.params[0].num = 1
msg.header.dataSize = 16
msg.header.signature = 789
msg.header.checksum = 101
msg.data[0] = 0x55
msg.dataSet(b"DDAATTATATA")
print(msg)

for i in range(128):
	msg.header.params[0].num = i
	CSRBvfsAPI.CSRBmessageSend(CSRBvfsHandle,
		"/MESSAGE/00000000000000000000000000000000/0000000000000010",
		fdMSG2,
		msg)
	time.sleep(1)

################################################################################

print("END")
time.sleep(7 * 24 * 3600)
