# Working with list data structure

num_list=[1,2,4,3]
#num_list.sort() # it will change the orignal list
#num_list.reverse() # it will change the orignal list

print(num_list)

#Extended slicing
print(num_list[::2]) # [1, 4] it will skip 1 index in that case
print(num_list[::-2]) # it will reverse the list and skip 1 but it is not adversible to do -ve index
print(num_list[1:4:-2]) #[]

#Append and Insert functions....
num_list.append(9) # Append will insert at the end.
num_list.insert(2,45) # it will insert the element into 2nd index.
num_list.remove(45) # remove the element 45
num_list.pop() # remove the last element
print(num_list)

#Mutable - can change and Immutable - cannot change

#list is mutable but tuple is immutable
tp=(1,2,3,4)
tp1=(1,) # when we make tuple with one  element then we need to use comma else result would be 1 only without bracket.

#swap the numbers
a=1
b=4
a,b= b,a
print(a,b)

#Dictionary in python ....
d1={}
print(type(d1))
d2={"Harry":"Burger","Rohan":"Fish","Shubham":{"B":"Maggie","L":"roti","D":"Chicken"}}
print(d2["Rohan"])
print(d2["Shubham"]) # Keys should be immutable.
print(d2["Shubham"]["B"])

d2["Ankit"]="Junk Food"
d2[420] ="Kabab"
print(d2)
del d2[420]
print(d2)

# d3=d2
# del d3["Harry"] # it will delete the value from both the dic coz d3 is pointing to d2 only not made copy of it. so use copy()
# print(d2)

# d3=d2.copy()
# del d3["Harry"]
# print(d2) # d2 is safe

print(d2.get("Harry"))
d2.update({"Leena":"Toffee"})
print(d2)
print(d2.keys())
print(d2.items())
print(d2.values())



