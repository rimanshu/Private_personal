#diamond shape problem is that problem occur on multiple inheritance where it might confuse that which method or variable needs
# to call. Python and C++ can handle that but Java doesnt have multiple inretance.

class A:
    def met(self):
        print("This is method of class A")

class B(A):
    def met(self):
        print("This is method of class B")

class C(A):
    def met(self):
        print("This is method of class C")

class D(B,C): # order of B and C should be wisely used.
    pass
    # def met(self):
    #     print("This is method of class D")

a=A()
b=B()
c=C()
d=D()

d.met()
# c.met()