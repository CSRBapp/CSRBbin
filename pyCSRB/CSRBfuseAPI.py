# vim: set ts=8 sw=8 tw=0 noet :
from CSRBprotocolMessage import *

def CSRBmessageOpen(filename):
	print("# opening [" + filename + "]")
	try:
		fm = open(filename, "rb+", buffering=0)
	except:
		return None
	print("# opened [" + filename + "]")
	return fm

def CSRBmessageClose(handle):
	try:
	    handle.close()
	except OSError as e:
		pass

def CSRBmessageAssembleSend(handle, reference, data, dataSize, signature, checksum):
	m = CSRBprotocolMessage()
	m.header.dataSize = dataSize
	m.data = data
	CSRBmessageSend(handle, msg)

def CSRBmessageSend(handle, msg):
	#print("# sending message:" + str(msg))
	try:
		handle.write(msg.toBuf())
		#handle.flush()
		#print("sent [" + str(msg) + "]")
		#print("sent [" + str(m.toBuf()) + "]")
	except OSError as e:
		print(e)
		if e.errno == 11:
			pass

def CSRBmessageReceive(handle):
	m=CSRBprotocolMessage()
	while True:
		buf = None
		try:
			#handle.seek(0)
			buf = handle.read(m.messageSize())
		except OSError as e:
			print(e)
			if e.errno == 11:
				time.sleep(0.1)
			elif e.errno == 107: # "Transport endpoint is not connected"
				return -1,None
			pass

		if buf and len(buf) == m.messageSize():
			m.fromBuf(buf)
			#print("# MESSAGE DATA SIZE: " + str(m.header.dataSize))
			#print("# MESSAGE DATA: " + str(m.data.decode('utf-8', errors='replace')))
			return len(buf),m
		elif buf:
			print("*** INVALID MESSAGE RECEIVED")
			if buf:
				print("\t (size: %u, [%s])" % (len(buf), str(buf)))
				print("\t" + str(len(buf)) + "/" + str(m.messageSize()))
			return 0,None
		else:
			return 0,None
	#return (m.reference, m.data, m.header.dataSize, m.signature, m.checksum)

