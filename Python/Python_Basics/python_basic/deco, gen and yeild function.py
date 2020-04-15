# Decorator
# If you want to use one thing at mutiple places then we use decorator like token check.
def dec1(fun):
    def execut1():
        print("Executing now")
        fun()
        print("Executed")
    return execut1

@dec1
def who():
    print("This is dummy decorator")

#who = dec1(who)

who()

# Generators . it is iterable like range function so it will have __iter__() and __getitem__()

def gen(n):
    for i in range(n):
        yield i # it will make function as genrator. it will not as return funciton.

g  = gen(3)

print(g.__next__())
print(g.__next__())
print(g.__next__())

import random

def lottery():
    # returns 6 numbers between 1 and 40
    for i in range(6):
        yield random.randint(1, 40)

    # returns a 7th number between 1 and 15
    yield random.randint(1,15)

for random_number in lottery():
       print("And the next number is... %d!" %(random_number))