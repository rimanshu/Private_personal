import matplotlib.pyplot as plt

# plt.plot([1,2,3],[9,7,8]) or 

x = [1,2,3]
y = ['Banking','pharma']

x2 = [1,2,3]
y2 = [10,14,12]

plt.pie(x,y)
#plt.scatter(x,y,label ='scatter', color ='b', marker='*', s=200) #s for size
#plt.plot(x,y, label = 'First Line') for simple chart 
#plt.plot(x2,y2, label = 'Second Line')
#plt.bar for bar chart
#plt.hist for histogram -- plt.hist(x,y,histtype='bar')
#plt.stackplot like area chart

plt.xlabel('X-Axis')
plt.ylabel('Y-Axis')

plt.title('First Graph')
plt.legend()
plt.show()




















