# vim: set ts=8 sts=8 sw=8 tw=0 noet:

import time
import ctypes
from CSRBprotocolMessage import *

def libraryLoad():
	global CSRBvfsLibrary

	CSRBvfsLibrary = ctypes.CDLL("libCSRBvfs.so")

	# need this as ctypes sometimes gets confused and converts to int32
	CSRBvfsLibrary.CSRBvfsInit.restype = ctypes.c_void_p

	ret = CSRBvfsLibrary.CSRBvfsImportTest()
	print("Import Test: %d" % ret)

def init(nodeid,
	bindHost, bindPort,
	routerHost, routerPort, routerInterspaceUSEC,
	nodeCAcertificateFile, nodeCertificateFile,
	vfsSectorSize,
	vfsCommandTimeoutMS, vfsCommandTimeoutRetries,
	storagePath):
	global CSRBvfsLibrary

	CSRBvfsHandle = ctypes.c_void_p()

	CSRBvfsHandle.value = CSRBvfsLibrary.CSRBvfsInit(
		ctypes.c_char_p(nodeid),
		ctypes.c_char_p(bindHost),
		bindPort,
		ctypes.c_char_p(routerHost),
		routerPort,
		routerInterspaceUSEC,
		ctypes.c_char_p(nodeCAcertificateFile),
		ctypes.c_char_p(nodeCertificateFile),
		vfsSectorSize,
		vfsCommandTimeoutMS,
		vfsCommandTimeoutRetries,
		ctypes.c_char_p(storagePath))

	#print("init: CSRBvfsHandle: %x" % CSRBvfsHandle.value)

	return CSRBvfsHandle;

def ls(CSRBvfsHandle, path, entries):
	global CSRBvfsLibrary

	entries.clear()

	_entries = (ctypes.c_char_p * 32)()
	for i in range(32):
		_entries[i] = ctypes.cast(ctypes.create_string_buffer(256), ctypes.c_char_p)
	#print(_entries)

	CSRBvfsLibrary.CSRBvfsReadDir(CSRBvfsHandle,
		ctypes.c_char_p(path.encode("utf-8")),
		_entries,
		256,
		32)

	for i in range(32):
		if len(_entries[i]):
			#print(_entries[i])
			entries.append(_entries[i])

def open(CSRBvfsHandle, file):
	global CSRBvfsLibrary

	_handle = ctypes.c_int64()

	CSRBvfsLibrary.CSRBvfsOpen(CSRBvfsHandle,
		ctypes.c_char_p(file.encode("utf-8")),
		ctypes.byref(_handle))

	return _handle.value

def read(CSRBvfsHandle, path, fd, buf, bufSize, readOffset):
	global CSRBvfsLibrary

	_buf = (ctypes.c_ubyte * bufSize)();

	ret = CSRBvfsLibrary.CSRBvfsRead(CSRBvfsHandle,
		ctypes.c_int64(fd),
		ctypes.c_char_p(path.encode("utf-8")),
		_buf,
		bufSize,
		readOffset)

	buf.clear()
	buf += bytearray(_buf)

	return ret

def write(CSRBvfsHandle, path, fd, buf, bufSize, writeOffset):
	global CSRBvfsLibrary

	_buf = (ctypes.c_ubyte * bufSize)(*(buf));

	ret = CSRBvfsLibrary.CSRBvfsWrite(CSRBvfsHandle,
		ctypes.c_int64(fd),
		ctypes.c_char_p(path.encode("utf-8")),
		_buf,
		bufSize,
		writeOffset)

	return ret

def CSRBmessageReceive(CSRBvfsHandle, path, fd):
	m = CSRBprotocolMessage()
	while True:
		buf = bytearray()
		ret = read(CSRBvfsHandle,
			path,
			fd,
			buf,
			m.messageSize(),
			0)
		if ret == 0:
			time.sleep(0.1)
			continue

		if ret == m.messageSize():
			m.fromBuf(buf)
			#print("# MESSAGE DATA SIZE: " + str(m.header.dataSize))
			#print("# MESSAGE DATA: " + str(m.data.decode("utf-8", errors="replace")))
			return m
		else:
			print("*** INVALID MESSAGE RECEIVED")
			if buf:
				print("\t (size: %u, [%s])" % (len(buf), str(buf)))
				print("\t" + str(len(buf)) + "/" + str(m.messageSize()))
			return None

def CSRBmessageSend(CSRBvfsHandle, path, fd, msg):
	#print("# sending message:" + str(msg))
	ret = write(CSRBvfsHandle,
		path,
		fd,
		msg.toBuf(),
		msg.messageSize(),
		0)
	#print("sent %u/%u" % (ret, msg.messageSize()))
	#print("sent [" + str(msg) + "]")
	#print("sent [" + str(m.toBuf()) + "]")
	return ret
