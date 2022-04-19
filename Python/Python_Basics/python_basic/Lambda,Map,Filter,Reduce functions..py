# Lambda Functions - Its one liner function. Mainly usedwith sort function where needs to give key in form of function.

minus = lambda x,y : x-y

print(minus(5,8))

# Join function

lis = ["1","2","3","4","5"]

for i in lis:
    print(i, "and ", end =" ")

a="and ".join(lis)
print(a)

# Map function - one liner function where we want to implement the things on every element on array or list.

list33 = [3,4,5,6]

for i in range(len(list33)):
    list33[i] = list33[i] +1

print(list33)
print(list(map(str,list33)))

num = [1,2,3,4]
square = list(map(lambda x: x*x, num))

print(square)

# Filter function - filter(function, iterable)
# function - function that tests if elements of an iterable returns true or false
# If None, the function defaults to Identity function - which returns false if any elements are false

alphabets = ['a', 'b', 'd', 'e', 'i', 'j', 'o']

print(filter,alphabets)

# Reduce function - it will reduce the list or any structure. If we want to add all elements of list.
from functools import reduce

list2 = [1,2,3,4]
num = reduce(lambda x, y : x+y, list2) # 10
