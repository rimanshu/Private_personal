# Escape sequence character and print statement.

print("Printing first line","Second Line will be seperated by space", end ="") # by default end ="\n"
print("Printing second line")
print("Printing first line","Printing second line") #printing two statement in same print.
print("He is \n good boy \t Rimanshu")
a = "boom"
b = "coom"
print(f"this is Fstring {a} and String format {b} {4*5}") # Fstrings.
# datatype and typecasting
print("Enter your number ")

inpnum=int(input()) # input function gives string so converted into integer.

print("You entered ", inpnum)

# String Slicing and other function.
mystr="He is good boy"
print(len(mystr))
print(mystr[0:8:2]) #2 means it will skip the one character,
print(mystr[0:10:4]) # 4 means it will skip the 3 characters
print(mystr[::20]) # if more than 14 then it will skip everything after that 1st character.
# work with negatiive index
print(mystr[::-1]) # reverse the string.
print(mystr[::-2])

#Work with some string fucntions
print(mystr.isalnum()) # it is not alphanumeric coz it has spaces between that
print(mystr.isalpha()) # it is also not aphabet characters coz it has strings.
print(mystr.endswith("boy")) # it will check thet string ends with boy or not.
print(mystr.count("o"))
print(mystr.capitalize())
print(mystr.find("is"))
print(mystr.upper())
print(mystr.replace("is","are"))