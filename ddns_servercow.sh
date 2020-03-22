#!/bin/bash

[[  -z "$DOMAIN" ]] && echo "ENV Var DOMAIN not set" && exit 1
[[  -z "$USER" ]] && echo "ENV Var USER not set" && exit 1
[[  -z "$PASSWORD" ]] && echo "ENV Var PASSWORD not set" && exit 1

INTERVAL="${INTERVAL:-120}"
SUBDOMAIN="${SUBDOMAIN:-$DOMAIN}"
SUBS=("$SUBDOMAIN")

function update_dns {
  for sub in ${SUBS[@]}; do
    curl -sS \
      --retry 3 \
      --connect-timeout 3 \
      --max-time 10 \
      --retry 3 \
      --retry-delay 0 \
      -X POST "https://api.servercow.de/dns/v1/domains/${DOMAIN}" \
      -H "X-Auth-Username: ${USER}" \
      -H "X-Auth-Password: ${PASSWORD}" \
      -H "Content-Type: application/json" \
      --data "{\"type\":\"A\",\"name\":\"${sub}\",\"content\":\"${IP_NOW}\",\"ttl\":120}"

    if [[ $? -eq 0 ]]; then 
      echo ": ${sub} updated to ${IP_NOW}"
    fi 
  done
}

function get_public_ip {
  curl -sS \
    --connect-timeout 3 \
    --max-time 5 \
    --retry 3 \
    --retry-delay 0 \
    --retry-max-time 15 \
    http://ifconfig.me
}

while true; do
  IP_NOW=$(get_public_ip)
  if [[ "$IP_LAST" != "$IP_NOW" ]]; then
    update_dns
  fi
  IP_LAST=$(get_public_ip)
  sleep $INTERVAL
done 
