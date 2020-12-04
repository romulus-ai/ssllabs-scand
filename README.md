# ssllabs-scand

This Image runs [ssllabs-scan](https://github.com/ssllabs/ssllabs-scan) utility in a defined interval to monitor the security of your websites over the time.

## Variables

The Resulting Container is fully configurable via Env Variables:

| Variablename | Description | Defaultvalue | Example |
| ------------ | ----------- | ------------ | ------- |
| URLS         | Space separated list of Domains to scan                  | -                                                  | www.google.de |
| PARAMS       | Parameter to pass to the ssllabs-scan utility            | --usecache --quiet --grade --hostfile /urlfile.txt | ensure a url is given or a hostfile |
| INTERVAL     | Interval in seconds to trigger a new scan                | 604800 (7 days)                                    | 86400 |
| ACCEPTED     | Accepted results, can be a pipe separated list for egrep | A+                                                 | A+|T|A |

## Results

The Results are written to a files in the directory "/var/log/ssllabs/".

* ssllabs-check.result -> This file will contain the raw result of the most recent scan
* weak-domains.result -> This file is only created if a domain does not match the accepted result, it will contain the failed domains

The weak-domains.result file will be removed as soon as the result matches again.

So the suggestion is to simple run this docker image on any of your hosts and mount volume to "/var/log/ssllabs/". Your monitoring solution simply has to check if a file "weak-domains.result" appears in you volume directory.