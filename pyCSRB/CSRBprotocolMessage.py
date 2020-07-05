# vim: set ts=8 sts=8 sw=8 tw=0 noet:

import ctypes
import math

class ObjectID(ctypes.Structure):
	_pack_ = 1
	_fields_ = [("id", ctypes.c_ulonglong * 2)]

	def __str__(self):
		return ''.join(format(x, '016X') for x in reversed(self.id))

class SASnetID(ctypes.Structure):
	_pack_ = 1
	_fields_ = [("id", ctypes.c_ulonglong * 2)]

	def __str__(self):
		return ''.join(format(x, '016X') for x in reversed(self.id))

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
			s += "\t param[" + str(c) + "]:" + str(self.params[c]) + "\n"
		s += "\t dataSize:" + str(self.dataSize) + "\n" \
			+ "\t signature:" + hex(self.signature) + "\n" \
			+ "\t checksum:" + hex(self.checksum)
		return s

class CSRBprotocolMessage(ctypes.Structure):
	_pack_ = 1
	_fields_ = [\
		("header", CSRBprotocolMessageHeader),
		("data", ctypes.c_ubyte * 32768)]

	def messageSize(self):
		return ctypes.sizeof(self)

	def __str__(self):
		s = "CSRBprotocolMessage:" + "\n\t" + str(self.header)
		#s += "\n\t data:"
		#for c in range(0, 8):
		#	s += self.data[c] + " "
		#s += "\t"
		return s

	def toBuf(self):
		size = self.messageSize()
		b = ctypes.create_string_buffer(size)
		ctypes.memmove(b, ctypes.addressof(self), size)
		return b.raw

	def fromBuf(self, buf):
		size = self.messageSize()
		ctypes.memmove(ctypes.addressof(self), buf, size)

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

