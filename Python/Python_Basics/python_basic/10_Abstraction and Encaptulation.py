#Abstraction means break code into peices like mouse,keyboard, usb, monitor for whole computer.
#Like one person make player class and other make city, third make 3d city class and then encaptulate all the class.
# We need to use abstraction to achieve encaptulation.
#Encaptulaton means hiding the implementation details of code. next programmer doesnt bother the privious class functionality
#He only use those functioality of class and continiue his work.

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

harry=Employee("Harry",344,"Instructor")
rohan=Employee("Rohan",543,"Student")
karan=Employee.form_str("karan-345-student")

print(Employee.printgood("Rohan"))