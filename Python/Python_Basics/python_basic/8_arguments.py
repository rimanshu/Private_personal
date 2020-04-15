# using *arg and **kwargs in python

# def function_name_print(a,b,c,d):
#     print(a,b,c,d)
#
# function_name_print("Harry","Rohan","Vimal","Rohit")

# but if we want to add one more argiment then we have to change in function but no need to do that

def funarg(*args):
    print(type(args)) #<class 'tuple'>
    print(args)

har=["Harry","Rohan","Vimal","Rohit","manu"] # we can add the values in the list only.
funarg(*har)

#function with arg arguments
def funargs12(normal,*arg): # sequence should be in this way.
    print(normal)
    for item in arg:
        print(item)

normal="I am the normal argument and students are ..... "

funargs12(normal,*har)

def funargs12(normal,*arg,**kwargs):
    print(normal)
    for item in arg:
        print(item)
    print("Now i would like to introduce some of our heros")
    for key,value in kwargs.items():
        print(key,value)

#**kwargs will take as dictionary while *args will use the list
kw={"Harry":"Monitor","The Programmer":"Coordinator"}

funargs12(normal,*har,**kw)

range(1)