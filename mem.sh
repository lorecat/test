#!/bin/sh
echo 3 >/proc/sys/vm/drop_caches
memtotal=`cat /proc/meminfo | grep MemTotal | awk '{print $2}'`
memfree=`cat /proc/meminfo | grep MemFree | awk '{print $2}'`
memused=`expr $memtotal - $memfree`
total=0
for pid in `ps | awk '{print $1}'`
do
 rss=`cat /proc/$pid/status | grep RSS | awk '{print $2}`
 if [ $rss ]; then
  echo `cat /proc/$pid/comm`\($pid\): $rss KB
  total=`expr $total + $rss`
 fi
done

echo userspace consumed: $total KB
echo kernel consumed: `expr $memused - $total` KB
echo total used: $memused KB
