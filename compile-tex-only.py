#! /usr/bin/env python
from os import listdir
from glob import glob
from os.path import isfile, join
from time import sleep,time,gmtime,strftime
import shlex
from callprocess import popenAndCall

numOfJob = 0
'''
	Anzahl der gestarteten lualatex Prozess
'''

lastJob = 0
'''
	index des letzten Job.
'''

tex_dir = "texfont"
'''
	Wo die generierten TeX Dateien gespeichert werden
'''
job = []
'''
	eine "Queue", wo die Dateiname der zu kompilierenden TeX-Dateien
	gespeichert werden. Es ist nicht Thread-Sage, aber in diesem Fall
	ist es egal. Siehe auch die try-catch block unten.
'''

def decrementJobNumber():
	print "decrement numOfJob"
	global numOfJob
	numOfJob = numOfJob-1
	try:
		print "start new job"
		startJob(job.pop())
		numOfJob = numOfJob +1
	except IndexError, ex:
		print "No more Job"
	pass

def startJob(jobName):
	cmd = "lualatex -output-directory=" \
		+ tex_dir \
		+ " -interaction nonstopmode " \
		+ jobName \
		+ ".tex"
	print "'", cmd, "'"
	arg = shlex.split(cmd)
	popenAndCall(decrementJobNumber,[arg])


# initialisieren die Jobs
def getJob():
	global job
	only_file =[ f for f in glob(tex_dir+"/*.tex")]
	for f in only_file:
		fn = f.split('.')[0]
		job.append(fn)
	print job
	return job


def doJob(sleepTime, maxPararelleJob):
	global numOfJob, lastJob, job
	start = time()
	while len(job) > 0 :
		print "job len: " + str(len(job))
		while numOfJob < maxPararelleJob:
			numOfJob = numOfJob +1
			try:
				startJob(job.pop())
			except IndexError, e:
				print "No more job"
			print "lastJob:" + str(lastJob) + " zZz"*20
			lastJob = lastJob+1
		sleep(sleepTime)
	end = time()
	return (start,end)
	
collect = file("statistic.csv","a")
#             numofjob       ,    sleeptime         ,     maxprocess , start, end
collect.write("#numofjob,sleeptime,maxprocess,start,end,diff\n")
collect.flush()
for maxjob in [4,5,6,3]:
	sleeptime = 10
	probe = 1
	while probe > 0:
		probe = probe - 1
		job = getJob()
		collect.write(str(len(job)) + ", "
				+ str(sleeptime) + ", "
				+  str(maxjob) + ", ")
		collect.flush()
		(s,e)=doJob(sleeptime, maxjob)
		collect.write(
				strftime("%d-%m-%y %H:%M:%S",gmtime(s)) + ", " 
				+ strftime("%d-%m-%y %H:%M:%S",gmtime(e)) + ", " 
				+ str(e-s) + "\n")
		collect.flush()

collect.close()



