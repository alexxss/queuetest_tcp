import matplotlib.pyplot as plt
import numpy as np

xv=[]
yv=[]
with open("jitter.txt","r") as f:
	for row in f:
		row = row.strip().split(' ')
		xv.append(row[0])
		yv.append(row[1])

plt.plot(xv,yv)

plt.xlabel('Time(s)')
plt.ylabel('Jitter(s)')
#plt.legend()
plt.show()
