# vim: set ts=8 sts=8 sw=8 tw=0 noet:

import ctypes
import math

class ObjectID(ctypes.Structure):
	_pack_ = 1
	_fields_ = [("id", ctypes.c_ulonglong * 2)]

	def __str__(self):
		return ''.join(format(x, '016X') for x in reversed(self.id))

	def fromHexString(self, hexString):
		hexString = hexString.zfill(32)
		self.id[1] = int(hexString[0:16], 16)
		self.id[0] = int(hexString[16:32], 16)

class SASnetID(ctypes.Structure):
	_pack_ = 1
	_fields_ = [("id", ctypes.c_ulonglong * 2)]

	def __str__(self):
		return ''.join(format(x, '016X') for x in reversed(self.id))

	def fromHexString(self, hexString):
		hexString = hexString.zfill(32)
		self.id[1] = int(hexString[0:16], 16)
		self.id[0] = int(hexString[16:32], 16)

class CSRBprotocolMessageHeaderParamType(ctypes.Structure):
	_pack_ = 1
	_fields_ = [\
		("id", SASnetID),
		("num", ctypes.c_ulonglong)]

	def __str__(self):
		return "id:" + str(self.id) + "/num:" + hex(self.num)

	def numHexBlocks(self, blockSize):
		return "{:08X}".format(math.ceil(self.num / blockSize))

class CSRBprotocolMessageHeader(ctypes.Structure):
	_pack_ = 1
	_fields_ = [\
		("type", ctypes.c_uint),
		("params", CSRBprotocolMessageHeaderParamType * 4),
		("dataSize", ctypes.c_uint),
		("signature", ctypes.c_ulonglong),
		("checksum", ctypes.c_ulonglong)]

	def __str__(self):
		s = "type:" + str(self.type) + "\n"
		for c in range(0, 4):
			s += "\tparam[" + str(c) + "]:" + str(self.params[c]) + "\n"
		s += "\tdataSize:" + str(self.dataSize) + "\n" \
			+ "\tsignature:" + hex(self.signature) + "\n" \
			+ "\tchecksum:" + hex(self.checksum)
		return s

class CSRBprotocolMessage(ctypes.Structure):
	_pack_ = 1
	_fields_ = [\
		("header", CSRBprotocolMessageHeader),
		("data", ctypes.c_ubyte * 32768)]

	def messageSize(self):
		return ctypes.sizeof(self)

	def dataSet(self, buf):
		ctypes.memmove(self.data, buf, min(len(self.data), len(buf)))

	def __str__(self):
		s = "CSRBprotocolMessage:" + "\n\t" + str(self.header)
		s += "\n\tdata: "
		for c in range(0, self.header.dataSize):
			s += hex(self.data[c]) + " "
		return s

	def toBuf(self):
		size = self.messageSize()
		b = ctypes.create_string_buffer(size)
		ctypes.memmove(b, ctypes.addressof(self), size)
		return b.raw

	def fromBuf(self, buf):
		size = self.messageSize()
		ctypes.memmove(ctypes.addressof(self), bytes(buf), size)

class CSRBprotocolCMDmoduleExecute(ctypes.Structure):
	_pack_ = 1
	_fields_ = [\
		("reference", ctypes.c_ulonglong),
		("module", ObjectID),
		("function", ctypes.c_char * 32),
		("parameters", ctypes.c_ulonglong * 8),
		("objects", ObjectID * 8),
		("references", ctypes.c_ulonglong * 8)]

	def toBuf(self):
		size = ctypes.sizeof(self)
		b = ctypes.create_string_buffer(size)
		ctypes.memmove(b, ctypes.addressof(self), size)
		return b.raw

