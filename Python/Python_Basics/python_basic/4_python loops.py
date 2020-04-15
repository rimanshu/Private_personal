# set in python. It will hold unique values.
#
# s=set()
# print(type(s))
# s_from_list=set([1,2,34])
# print(s_from_list) #{1, 2, 34}
# print(type(s_from_list))
#
# s.add(1)
# s.add(1)# It will make unique
# s1=s.intersection([1,2])
# s1=s.union([1,2])
# print(s1)

# If and else loop...
# var1=3
# var2=34
# var3=int(input("Enter value"))
#
# if var3>var2:
#     print("Greater")
# elif var3==var2:
#     print("Equal")
# else:
#     print("Lesser")

# list1=[1,2,4,5,6]
#
# if 5 in list1:
#     print("yes it is in list")
# if 8 not in list1:
#     print("It is not in list")

# For loop in python

# list1=[["Harry",3],["Larry",5],["Carry",1],["Marie",9]]
#
# dict1=dict(list1)
# print(dict1)
#
# for item,value in list1: # unpack the list of list
#     print(item, "and value is ",value,"\n")
#
# for item, value in dict1.items():
#     print(item, "and value is ",value,"\n")
#
# for item in dict1:
#     print(item)


#While loops in python

# i=0
#
# while(i<45):
#     print(i)
#     i=i+1

#Break and continue in python

i=0

while(True): # True or 1 will never stop loop
    i = i + 1
    if i <5:
        continue # ignore the thing
    print(i+1, end=" ")
    if(i==44):
        break # Stop the loop

#Operators in python
#/ will divide but // will give interger only like divident, % will give rimender, ** will give power.

