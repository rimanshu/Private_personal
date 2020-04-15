class Employee:
    no_of_leaves=10

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

class Programmer(Employee): # single level inheritance.
    no_of_holy=45
    def __init__(self,aname, asalary, arole,alanguage):
        self.name=aname
        self.salary=asalary
        self.role=arole
        self.language=alanguage

    def printprog(self):
        return f"Programmer Name is {self.name} . salary is {self.salary} and role is {self.role}. The languages are {self.language}"

class Player:
    no_of_games=4

    def __init__(self,aname,agame):
        self.name=aname
        self.game=agame

    def printdetail(self):
        return f"Name is {self.name} . game is {self.game}"

class CoolProgrammer(Employee,Player): #Multiple inherantance. where more than one class inherits.
    pass

harry=Employee("Harry",344,"Instructor")
rohan=Employee("Rohan",543,"Student")
shubham=Programmer("Shubham",654,"Programmer",["python"])
Karan=Programmer("karan",754,"Programmer",["python","C++"])

shubham=Player("Shubham",["Cricket"])

Arjun=CoolProgrammer("Arjun",3456,"Coolprog") #for multiple nheritance.
print(Arjun.printdetail())  #it will use function whose present first in parametrs in Coolprogram class.

print(Karan.printprog())
print(Karan.printdetail())
print(Karan.no_of_holy)


#----------------------------MULTILEVEL INHERITANCE----------------------------------------------------

class Dad:
    basketball=1

class Son(Dad):
    dance =1
    def isdance(self):
        return f"yes i dance {self.dance} no of times"

class Grandson(Son): # This is multi level inheritance
    dance =6

    def isdance(self):
        return f"Yes i dance very awesomely {self.dance} no of times"

darry=Dad()
larry=Son()
harry=Grandson()

print(harry.isdance()) #Yes i dance very awesomely 6 no of times. it means it will overrite the function of Son

print(harry.basketball)