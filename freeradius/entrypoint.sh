#!/bin/bash

envsubst '${CLIENT_NETWORK},${CLIENT_NETMASK},${CLIENT_SECRET}' < clients.conf.template > /etc/freeradius/clients.conf

envsubst '${USER_NAME},${USER_PASS}' < users.template > /etc/freeradius/users

if [[ $USE_DB == "true" ]];then
  envsubst '${DB_USER},
            ${DB_PASS},
            ${DB_HOST}
            ${DB_NAME}' < sql.conf.template > /etc/freeradius/sql.conf
  /bin/cp default.template /etc/freeradius/sites-available/default
  /bin/cp inner-tunnel.template /etc/freeradius/sites-available/inner-tunnel
  /bin/cp radiusd.conf.template /etc/freeradius/radiusd.conf
  sed -ri 's@#(.*sql.conf)@\1@g' /etc/freeradius/radiusd.conf
  sed  -i 's@^$INCLUDE clients.conf@#&@g' /etc/freeradius/radiusd.conf
fi

IMPORT_TABLES=$(mysql -u${DB_USER} -p${DB_PASS} -h${DB_HOST} -e "use radius;show tables"|wc -l)

if [ $IMPORT_TABLES -eq 0 ];then
   mysql -u${DB_USER} -p${DB_PASS} -h${DB_HOST} ${DB_NAME} < /etc/freeradius/sql/mysql/admin.sql
   mysql -u${DB_USER} -p${DB_PASS} -h${DB_HOST} ${DB_NAME} < /etc/freeradius/sql/mysql/ippool.sql
   mysql -u${DB_USER} -p${DB_PASS} -h${DB_HOST} ${DB_NAME} < /etc/freeradius/sql/mysql/cui.sql
   mysql -u${DB_USER} -p${DB_PASS} -h${DB_HOST} ${DB_NAME} < /etc/freeradius/sql/mysql/nas.sql
   mysql -u${DB_USER} -p${DB_PASS} -h${DB_HOST} ${DB_NAME} < /etc/freeradius/sql/mysql/wimax.sql
   mysql -u${DB_USER} -p${DB_PASS} -h${DB_HOST} ${DB_NAME} < /etc/freeradius/sql/mysql/schema.sql
fi

NAS_VALUE=$(mysql -u${DB_USER} -p${DB_PASS} -h${DB_HOST} ${DB_NAME} -e "select * from  ${DB_NAME}.nas "|wc -l)
if  [ $IMPORT_TABLES -eq 0 ];then
    mysql -u${DB_USER} -p${DB_PASS} -h${DB_HOST} ${DB_NAME} -e "INSERT INTO ${DB_NAME}.nas (nasname,shortname,type,ports,secret) VALUES('${CLIENT_NETWORK}/${CLIENT_NETMASK}','private-network
-1','other',1812,'${CLIENT_SECRET}');"
   mysql -u${DB_USER} -p${DB_PASS} -h${DB_HOST} ${DB_NAME} -e "INSERT INTO ${DB_NAME}.radgroupreply (groupname,attribute,op,value) VALUES ('user','Auth-Type',':=','Local');"
   mysql -u${DB_USER} -p${DB_PASS} -h${DB_HOST} ${DB_NAME} -e "INSERT INTO ${DB_NAME}.radgroupreply (groupname,attribute,op,value) VALUES ('user','Service-Type',':=','Framed-User');"
   mysql -u${DB_USER} -p${DB_PASS} -h${DB_HOST} ${DB_NAME} -e "INSERT INTO ${DB_NAME}.radgroupreply (groupname,attribute,op,value) VALUES  ('user','Framed-IP-Address',':=','255.255.255.255'
);"
   mysql -u${DB_USER} -p${DB_PASS} -h${DB_HOST} ${DB_NAME} -e "INSERT INTO ${DB_NAME}.radgroupreply (groupname,attribute,op,value) VALUES ('user','Framed-IP-Netmask',':=','255.255.255.0');"
   mysql -u${DB_USER} -p${DB_PASS} -h${DB_HOST} ${DB_NAME} -e "INSERT INTO ${DB_NAME}.radcheck (username,attribute,op,value) VALUES ('${USER_NAME}','Cleartext-Password',':=','${USER_PASS}')
;"
   mysql -u${DB_USER} -p${DB_PASS} -h${DB_HOST} ${DB_NAME} -e "INSERT INTO ${DB_NAME}.radusergroup (username,groupname) VALUES ('${USER_NAME}','user');"
fi


exec "$@"
