# Simple script to calculate which instruction to make twice as fast (halve the number of cycles per instruction.)


# Main method
if __name__ == "__main__":
	ops = ["Loads", "Stores", "Adds", "Multiplies", "Divides", "Conditional Branch", "Unconditional Branch"]
	freq = [0.3, 0.1, 0.4, 0.08, 0.02, 0.08, 0.02]
	#cpi = [4, 6, 2, 12, 40, 4, 2]

	cpi = [4, 6, 2, 12, 40, 4, 1]

	summ = 0

	for i in range(0,7):
		summ += (freq[i] * cpi[i])

	print(summ)