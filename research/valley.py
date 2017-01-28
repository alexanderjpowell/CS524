# Display plot between number of threads and GOPS

import numpy as np
import matplotlib.pyplot as plt

alpha = 3.5
beta = 13

def probabilityOfHit(x):
	return 1 - (((x / beta) + 1) ** (-1 * (alpha - 1)))

def averageCycleTime(numThreads):
	a = probabilityOfHit(16000 / numThreads) * 10
	b = (1 - probabilityOfHit(16000 / numThreads)) * 200
	return a + b

def getN(numThreads):
	a = numThreads / (1024 * (1 + averageCycleTime(numThreads) * (0.2 / 1)))
	return min(1, a)

def performance(numThreads):
	return 1024 * getN(numThreads)


if __name__ == "__main__":
	threads = []
	GOPS = []
	probability = []

	for i in xrange(1, 10000, 10):
		threads.append(i)
		GOPS.append(performance(i))

	#for i in threads:
	#	GOPS.append(performance(i))

	for i in threads:
		probability.append(probabilityOfHit(16000000/i))


	plt.xlabel('Number of Threads')
	plt.ylabel('Performance')
	plt.plot(threads, GOPS, '-o')
	#plt.scatter(threads, GOPS)
	#plt.scatter(threads, probability)
	plt.show()



