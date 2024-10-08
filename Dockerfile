FROM	debian:testing-slim

RUN	apt-get update && \
	apt-get install -y libstdc++6 && \
	apt-get install -y openssl && \
	apt-get clean

RUN	mkdir /CSRB /CSRB/DEBIAN-TESTING /CSRBSTORAGE

ADD	DEBIAN-TESTING/CSRBnode.enc \
	SCRIPTS/bins-decrypt.sh \
	/CSRB/DEBIAN-TESTING/

ADD	SCRIPTS/tune-linux.sh \
	SCRIPTS/os-detect.sh \
	SCRIPTS/env.sh \
	SCRIPTS/checks.sh \
	SCRIPTS/start-CSRBnode.sh \
	CERTS/CA.nodes.csrb.crt \
	CERTS/C9BAD58F23D5A6C095C0571512CD318D.nodes.csrb.pem \
	/CSRB/

ENV	CA_CERT=/CSRB/CA.nodes.csrb.crt \
	NODE_CERT=/CSRB/C9BAD58F23D5A6C095C0571512CD318D.nodes.csrb.pem \
	BINDIR=/CSRB/DEBIAN-TESTING/ \
	STORAGE_PATH=/CSRBSTORAGE/

CMD	cd /CSRB/DEBIAN-TESTING && ./bins-decrypt.sh $PASSWORD && /CSRB/start-CSRBnode.sh
