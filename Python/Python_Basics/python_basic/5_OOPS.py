# main function .......
# when we import the library or other file then it will execute the whole fucntion present in files.
def test():
    print("testing")
print("value of __name__ is ...........",__name__) # it will the __main__ value when run from this file.

if __name__ == '__main__': # it is mainly used when we try to run program from main function. This main will execute when we run
    # from here. it will not execute from other file.
    test()


# Class and Objects

#Class is a template and object is letter. Like we want to make letter so just make a template of class. Object is letter.

#Object - instance of class means instance get from class. Class works on DRY concept that means do not repeat Yourself.

class Student:
    pass

harry =Student()
larry=Student()

harry.name="harry"
harry.std=12
larry.name="Rohan"
larry.std=9
print(harry,larry)
print(harry.name,harry.std,larry.name,larry.std) # you can add anything in objects which declared from class.

class Employee:
    no_of_leaves=10 # It is class variable. it can be shared by all objects. no object change that value.
    pass

harry=Employee()
rohan=Employee()
harry.name="Harry"
harry.salary=455
harry.role="Instructor"
rohan.name="Rohan"
rohan.salary=324
rohan.role="Student"
#rohan.no_of_leaves=9 it will change the value for rohan only but not Employee class. It is instance variable

print(harry.no_of_leaves,rohan.no_of_leaves,Employee.no_of_leaves) #All gives same values.
print(harry.__dict__) # WIll provide the object details and values in dictionary.
print(rohan.__dict__)
print(Employee.__dict__)

class Employee:
    no_of_leaves=10

    #constructor - A constructor is a special type of method (function) which is used to initialize the instance members of the class.
    def __init__(self, aname, asalary, arole):
        self.name=aname
        self.salary=asalary
        self.role=arole

    #methods in class.
    def printdetail(self): # self means it is that instance where it been applied.same as object name where used.
        return f"Name is {self.name} . salary is {self.salary} and role is {self.role}"

harry=Employee("Harry",455,"Instructor") # when u want to give arg in class then it will be called as construtor.
rohan=Employee()

harry.name="Harry"
harry.salary=455
harry.role="Instructor"

rohan.name="Rohan"
rohan.salary=324
rohan.role="Student"

print(harry.salary)

#Class methods .........

class Employee:
    no_of_leaves=10

    def __init__(self, aname, asalary, arole):
        self.name=aname
        self.salary=asalary
        self.role=arole

    def printdetail(self):
        return f"Name is {self.name} . salary is {self.salary} and role is {self.role}"

    @classmethod
    def change_leaves(cls,new_leaves): #It will change the varaible of class by instance.It will not use self.
        #cls is class whose instance will be harry. or it is EMployee class.
        # If we will not use that then it will use self and instance object will not able to change the class variable.
        cls.no_of_leaves=new_leaves
        return cls.no_of_leaves

harry=Employee("Harry",455,"Instructor")

print(harry.change_leaves(32))

# class method as Alternative constructor
class Employee:
    no_of_leaves=10

    def __init__(self, aname, asalary, arole):
        self.name=aname
        self.salary=asalary
        self.role=arole

    def printdetail(self):
        return f"Name is {self.name} . salary is {self.salary} and role is {self.role}"

    @classmethod
    def change_leaves(cls,new_leaves): #It will change the  varaible of class by instance.It will not use self.
        #cls is class whose instance will be harry. or it is Employee class.
        # If we will not use that then it will use self and intance object will not able to change the class variable.
        cls.no_of_leaves=new_leaves
        return cls.no_of_leaves

    @classmethod
    def form_str(cls,string):
        param=string.split("-")
        #return cls(*string.split("-")) - one liner code.
        return cls(param[0],param[1],param[2])

# When we give argument to the class object then it is called as constructor. Like __init__ function.
# Constructor use to initialize the member varaible in class.

harry=Employee("Harry",455,"Instructor") # constructor
karan=Employee.form_str("karan-345-student") # class method as alternative constructor.

print(harry.change_leaves(32))

#static method - if you dont want instance or class variable and want to use in any object only.
#if we want to make function which doesnt take argument from class and intance and work independtly.
class Employee:
    no_of_leaves=10

    def printdetail(self):
        return f"Name is {self.name} . salary is {self.salary} and role is {self.role}"

    @classmethod
    def change_leaves(cls,new_leaves):
        cls.no_of_leaves=new_leaves
        return cls.no_of_leaves

    @staticmethod # it will be run from any instance only of class.
    def printgood(string):
        print("This is good",string)
        return 65

karan=Employee()
print(karan.printgood("Harry")) # it will be used from instance.
print(Employee.printgood("Rohan"))# it can be used by class also