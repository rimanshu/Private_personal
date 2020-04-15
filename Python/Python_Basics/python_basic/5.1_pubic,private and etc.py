# Public - ghar ke bahar kajag cipka diya
# Protected - ghar ke andar kagaj chipka diya
# Private - room main chipka diya kagaj

class Employee:
    no_of_leaves=10 # This is Public Variables.
    _protect=45 # Protected variable. It can be access by class intance or drived class like inheritance but cannot access
    # by outside any function or class.
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
print(emp.printdetail())
print(emp.change_leaves(45))
