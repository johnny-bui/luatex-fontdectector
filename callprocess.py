import threading
import subprocess
import shlex

def popenAndCall(onExit, popenArgs):
	"""
	Runs the given args in a subprocess.Popen, and then calls the function
	onExit when the subprocess completes.
	onExit is a callable object, and popenArgs is a list/tuple of args that 
	would give to subprocess.Popen.
	"""
	def runInThread(onExit, popenArgs):
		texOutStream = devnull()
		proc = subprocess.Popen(*popenArgs,stdout=texOutStream)
		#proc = subprocess.Popen(popenArgs,shell=True)
		proc.wait()
		onExit()
		return
	thread = threading.Thread(target=runInThread, args=(onExit, popenArgs))
	thread.start()
	# returns immediately after the thread starts
	return thread

class devnull(object):
	def write(self,*_):pass
	def fileno(self):pass


