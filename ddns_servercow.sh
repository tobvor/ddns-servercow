#!/bin/bash

[[  -z "$DOMAIN" ]] && echo "ENV Var DOMAIN not set" && exit 1
[[  -z "$USER" ]] && echo "ENV Var USER not set" && exit 1
[[  -z "$PASSWORD" ]] && echo "ENV Var PASSWORD not set" && exit 1

INTERVAL="${INTERVAL:-120}"
SUBDOMAIN="${SUBDOMAIN:-$DOMAIN}"
SUBS=("$SUBDOMAIN")
IPv4="${IPv4:-true}"
IPv6="${IPv6:-false}"

function get_public_ip_v4 {
  curl -4 -sS \
    --connect-timeout 3 \
    --max-time 5 \
    --retry 3 \
    --retry-delay 0 \
    --retry-max-time 15 \
    http://ifconfig.co
}

function get_public_ip_v6 {
  curl -6 -sS \
    --connect-timeout 3 \
    --max-time 5 \
    --retry 3 \
    --retry-delay 0 \
    --retry-max-time 15 \
    http://ifconfig.co
}

function update_dns_v4 {
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
      --data "{\"type\":\"A\",\"name\":\"${sub}\",\"content\":\"${IP_NOW_V4}\",\"ttl\":120}"

    if [[ $? -eq 0 ]]; then 
      echo ": ${sub} updated to ${IP_NOW_V4}"
    fi 
  done
}

function update_dns_v6 {
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
      --data "{\"type\":\"AAAA\",\"name\":\"${sub}\",\"content\":\"${IP_NOW_V6}\",\"ttl\":120}"

    if [[ $? -eq 0 ]]; then
      echo ": ${sub} updated to ${IP_NOW_V6}"
    fi
  done
}


while true; do
  # IPv4
  if [ "$IPv4" == "true" ]; then
    IP_NOW_V4=$(get_public_ip_v4)
    if [[ "$IP_LAST_V4" != "$IP_NOW_V4" ]]; then
      update_dns_v4
    fi
    IP_LAST_V4=$(get_public_ip_v4)
  fi

  # IPv6
  if [ "$IPv6" == "true" ]; then
    IP_NOW_V6=$(get_public_ip_v6)
    if [[ "$IP_LAST_V6" != "$IP_NOW_V6" ]]; then
      update_dns_v6
    fi
    IP_LAST_V6=$(get_public_ip_v6)
  fi

  sleep $INTERVAL
done
