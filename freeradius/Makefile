build:
	docker build  -t test .

start:
	docker run --name test -p 1812:1812/udp -p 1813:1813/udp --env-file  ../freeradius.env -d test

stop:
	docker rm -f test
       
start-mysql:
	docker run -itd \
          --name=mysql \
          -p 3306:3306 \
          -e MYSQL_ROOT_PASSWORD=123456 \
          -e MYSQL_DATABASE=radius \
        mysql:5.6

stop-mysql:
	docker rm -f mysql
