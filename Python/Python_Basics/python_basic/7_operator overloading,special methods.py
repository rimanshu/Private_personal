#Operator overloading - If we want to add two class object the it will call __add__ method by default so we have include that function.
# + operator will call that __add__ function as like / operator will call truediv function.
# https://docs.python.org/2.4/lib/operator-map.html

class Employee:
    no_of_leaves=10

    def __init__(self, aname, asalary, arole): # Dunder method and constructor
        self.name=aname
        self.salary=asalary
        self.role=arole

    def printdetail(self):
        return f"Name is {self.name} . salary is {self.salary} and role is {self.role}"

    @classmethod
    def change_leaves(cls,new_leaves):
        cls.no_of_leaves=new_leaves
        return cls.no_of_leaves

    def __add__(self, other): #special method or dunder method.
        return self.salary + other.salary

    def __repr__(self): # When we trying to print the class object then this function calls.
        return f"Employee('{self.name}',{self.salary},'{self.role}')"

    # def __str__(self):  #BY default it will call when try to print the class object.
    #     return f"Name is {self.name} . salary is {self.salary} and role is {self.role}"

emp1=Employee("Harry", 213, "Programmer")
emp2=Employee("Rohan" ,120, "Cleaner")

print(emp1 + emp2)
print(emp1) # when str method is there then it will print the result of str but it is not there then repr will return.
print(str(emp1)) # it will same as we used str method in class