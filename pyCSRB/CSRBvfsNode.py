# vim: set ts=8 sts=8 sw=8 tw=0 noet:

import os
import time
import random
import string
import socket
import hashlib

import CSRBvfsAPI
from CSRBprotocolMessage import *

fqdn = socket.getfqdn()
print("FQDN: %s" % fqdn)

username = os.getenv("USER") or ''.join(random.choice(string.ascii_lowercase) for i in range(8))
print("USERNAME: %s" % username)

nodeidstring = username + "@" + fqdn
nodeidhash = hashlib.md5()
nodeidhash.update(nodeidstring.encode("utf-8"))
nodeid = nodeidhash.hexdigest().upper()
print("NODEID: %s (%s)" % (nodeid, nodeidstring))

storagePath = os.getenv("STORAGEPATH") or "/tmp/CSRBSTORAGE"
print("STORAGEPATH: %s" % storagePath)

routerHost = os.getenv("ROUTERHOST") or "public.csrb.app"
print("ROUTERHOST: %s" % routerHost)

CSRBvfsAPI.libraryLoad()
CSRBvfsHandle = CSRBvfsAPI.init(
	nodeid = nodeid.encode("utf-8"),
	bindHost = b"0.0.0.0",
	bindPort = 0,
	routerHost = routerHost.encode("utf-8"),
	routerPort = 32450,
	routerInterspaceUSEC = 0,
	nodeCAcertificateFile = b"../CERTS/CA.nodes.csrb.crt",
	nodeCertificateFile = b"../CERTS/C9BAD58F23D5A6C095C0571512CD318D.nodes.csrb.pem",
	vfsSectorSize = 32768,
	vfsCommandTimeoutMS = 3301,
	vfsCommandTimeoutRetries = int((500 * 1000) / 3301),
	storagePath = storagePath.encode("utf-8"))

print("CSRBvfsHandle: ", hex(CSRBvfsHandle.value))

if __name__ == '__main__':
	print("CSRB VFS NODE STARTED")
	while True:
		time.sleep(random.randrange(300, (24 * 3600)))
