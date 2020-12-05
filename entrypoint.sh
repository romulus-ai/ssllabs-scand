#!/bin/bash

# First write all the URLs to check to a configfile, one URL per line
for url in ${URLS} ; do
  if ! egrep ^${url}$ ./urlfile.txt >/dev/null ; then
    echo "Adding $url to URL List"
    echo $url >> /urlfile.txt
  else
    echo "$url already in domainlist"
  fi
done

while (true) ; do
  echo "[INFO] $(date): starting ssllabs scan"
  /ssllabs-scan ${PARAMS} > /var/log/ssllabs/ssllabs-check.result
  echo "[INFO] $(date): finished ssllabs scan with exitcode $?"
  rm -f /var/log/ssllabs/weak-domains.result | true
  for url in ${URLS} ; do
    if [ $(grep \"${url}\" /var/log/ssllabs/ssllabs-check.result | egrep ${ACCEPTED} | wc -l) -eq 0 ] ; then
      echo "[INFO] $(date): found weak domain ${url}"
      echo "${url}" >> /var/log/ssllabs/weak-domains.result
    fi
  done
  echo "[INFO] $(date): sleeping ${INTERVAL} seconds"
  sleep ${INTERVAL}
done