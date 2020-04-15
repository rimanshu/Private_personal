#Polymorphism - It is ability to take diff forms. In this, we will see the diff form of same things.
#It can be achieved by override the method or variable.


# + operator is working as polymorphism because it will give result diff in diff cases.
print(5+6)
print("5"+"6")

class A:
    classvar1="I am in class A" # when instance made for this class then it will print class variable coz there is no instance variable there.

    def __init__(self):
        self.var1="I am in class A constructor"
        self.classvar1="Instance var in class A" # It will print when instance made.
        self.special="Special"
class B(A):
    classvar1="I am in class B"
    def __init__(self):
        super().__init__()
        self.var1="I am in class A constructor"
        self.classvar1="Instance var in class B" #it will be printed coz instance function here.
        #super().__init__() # it will call after then it will use all the variable from it.
a=A()
b=B()

# Instance variable will find and print first then class variable.
# When classvar2 will called from class B then it will find the instance variable in class B and it will not found then it will
#check in inherited class then lookout for class varaible in B then A.
print(b.classvar1)
print(b.special,b.var1,b.classvar1) #AttributeError: 'B' object has no attribute 'special' because it has been overwrite to class A.


class Employee:
    no_of_leaves=10 # This is Public Variables.
    _protect=45 # Protected variable. It can be access by class intance or drived class like inheritance but cannot access
    #by outside any function or class.
    __private=598 # It is private variable. It will be use in this class only. it will not accessed by drived class also.
    def __init__(self, aname, asalary, arole):
        self.name=aname
        self.salary=asalary
        self.role=arole

    def printdetail(self):
        return f"Name is {self.name} . salary is {self.salary} and role is {self.role}"

    @classmethod
    def change_leaves(cls,new_leaves):
        cls.no_of_leaves=new_leaves
        return cls.no_of_leaves

    @classmethod
    def form_str(cls,string):
        param=string.split("-")
        #return cls(*string.split("-")) - one liner code.
        return cls(param[0],param[1],param[2])

    @staticmethod # it will be run from any instance only of class.
    def printgood(string):
        print("This is good",string)
        return 65

emp=Employee("harry",32,"Instructor")
print(emp._protect) # This is how protected varaibles accessed.
print(emp._Employee__private) # this is hot private variable accessed.
