#!/bin/bash

if [[ $USE_RADIUS == "true" ]];then
  sed -i  's@radius_deadtime.*@#&@g' /usr/local/etc/radiusclient/radiusclient.conf
  sed -i  's@bindaddr.*@#&@g' /usr/local/etc/radiusclient/radiusclient.conf
  envsubst '${RADIUS_SERVER}' < radiusclient.conf.template > /usr/local/etc/radiusclient/radiusclient.conf

  envsubst '${RADIUS_SERVER},
            ${CLIENT_SECRET},
           ' < servers.template > /usr/local/etc/radiusclient/servers
fi

/bin/cp dictionary.template /usr/local/etc/radiusclient/dictionary
/bin/cp dictionary.microsoft.template /usr/local/etc/radiusclient/dictionary.microsoft 

exec "$@"
