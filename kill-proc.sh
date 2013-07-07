#!/bin/sh
echo process:
ps aux | grep python | grep compile 
PROCESS=`ps aux | grep python | grep compile | cut -f7 -d" "`
for processes in $PROCESS ; do
	echo kill process: $processes
	kill -9 $processes
done
