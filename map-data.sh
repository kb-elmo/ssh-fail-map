#!/bin/bash

ips=$(mktemp)
cntrs=$(mktemp)

grep "\[preauth\]\|Invalid user\|maximum authentication attempts\|Did not receive identification" /var/log/auth.log.1 |\
   grep -o "\([0-9]\{1,3\}\.\)\{3\}[0-9]\{1,3\}" | sort > $ips

while read ip; do
   geoiplookup $ip | sed 's/GeoIP\ Country\ Edition\:\ //g; s/\, .*//g' >> $cntrs
done < $ips

cat $cntrs | sort | uniq -c | sort -rh | sed '/hostname/d' | awk '{print tolower($2)" = "$1}' > /var/www/map/data.txt

rm $ips
rm $cntrs
