# Display plot between number of threads and GOPS

import numpy as np
import matplotlib.pyplot as plt

N_pe = 1024           # Number of processing elements
cache_size = 16000 # in bytes
N_max = 65536
cpi = 1
f = 1
cache_lat = 1
mem_lat = 200
BW_max = 200
b_reg = 4
r_m = 0.3
alpha = 3.5
beta = 13

def probabilityOfHit(numthreads):
	ret = 1 - (cache_size/(numthreads * beta) + 1) ** (-1 * (alpha - 1))
	if (ret == 1):
		return 0.99
	return ret

def getT_AVG(numthreads):
	hit = probabilityOfHit(numthreads)
	miss = 1 - hit
	return hit * cache_lat + miss * mem_lat

def getN(numthreads):
	ret = numthreads/(N_pe * (1 + getT_AVG(numthreads) * (r_m/cpi)))
	return min(1, ret)

def getPerformance(numthreads):
	a = N_pe * (f/cpi) * getN(numthreads)
	b = BW_max/(r_m * b_reg * (1 - probabilityOfHit(numthreads)))
	return min(a, b)


if __name__ == "__main__":
	threads = []
	gops = []

	for i in xrange(1, 20000, 10):
		threads.append(i)
		gops.append(getPerformance(i))


	plt.xlabel('Number of Threads')
	plt.ylabel('Performance')
	plt.plot(threads, gops, '-o')
	plt.show()






