# vim: set ts=8 sts=8 sw=8 tw=0 noet:

import ctypes
import math
import bitstruct

class MessageID(ctypes.Structure):
	_pack_ = 1
	_fields_ = [("id", ctypes.c_ulonglong)]

	def __str__(self):
		return format(self.id, "016X")

	def fromHexString(self, hexString):
		hexString = hexString.zfill(16)
		self.id = int(hexString, 16)

	def toHexString(self):
		return self.__str__()

	def fromBytes(self, b):
		self.id = int.from_bytes(b, byteorder="little", signed=False)

class ObjectID(ctypes.Structure):
	_pack_ = 1
	_fields_ = [("id", ctypes.c_ulonglong * 2)]

	def __str__(self):
		return ''.join(format(x, "016X") for x in reversed(self.id))

	def fromHexString(self, hexString):
		hexString = hexString.zfill(32)
		self.id[1] = int(hexString[0:16], 16)
		self.id[0] = int(hexString[16:32], 16)

	def toHexString(self):
		return self.__str__()

class SASnetID(ctypes.Structure):
	_pack_ = 1
	_fields_ = [("id", ctypes.c_ulonglong * 2)]

	def __str__(self):
		return ''.join(format(x, "016X") for x in reversed(self.id))

	def fromHexString(self, hexString):
		hexString = hexString.zfill(32)
		self.id[1] = int(hexString[0:16], 16)
		self.id[0] = int(hexString[16:32], 16)

	def toHexString(self):
		return self.__str__()

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
		("moduleNodeID", SASnetID),
		("moduleObjectID", ObjectID),
		("moduleFunction", ctypes.c_char * 32),
		("functionParameters", ctypes.c_ulonglong * 8),
		("functionObject", ObjectID * 8),
		("functionReferences", ctypes.c_ulonglong * 8)]

	def toBuf(self):
		size = ctypes.sizeof(self)
		b = ctypes.create_string_buffer(size)
		ctypes.memmove(b, ctypes.addressof(self), size)
		return b.raw

	def ioctlCommandGenerate():
		#ioctlCmd = bitstruct.byteswap("8", bitstruct.pack(">u2u14u8u8", 3, ctypes.sizeof(CSRBprotocolCMDmoduleExecute), 1, 1))
		ioctlCmd = bitstruct.pack(
			">u3u13u8u8",
			6,
			ctypes.sizeof(CSRBprotocolCMDmoduleExecute),
			1,
			1
		)

		#print("ioctlCmd initial assembly: " + ioctlCmd.hex())
		ioctlCmd = bitstruct.byteswap("8", ioctlCmd)
		#print("ioctlCmd byte swapped: " + ioctlCmd.hex())

		ioctlCmdInt = int.from_bytes(ioctlCmd, byteorder='little')
		#print("ioctlCmdInt LE int: " + str(hex(ioctlCmdInt)))

		return ioctlCmdInt