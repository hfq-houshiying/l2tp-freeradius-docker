start:
	docker run -d --name testvpn \
	--env-file  ../l2tp.env \
	-v /lib/modules:/lib/modules:ro \
	-p 500:500/udp \
	-p 4500:4500/udp \
	-d --privileged \
	vpntest

build:
	docker build  -t vpntest .

stop:
	docker rm -f testvpn

exec:
	docker exec -dit testvpn /bin/bash
