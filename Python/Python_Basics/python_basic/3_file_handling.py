num1=input("Enter first number ")
num2=input("Enter secodn number")

try:
    print("The sum of two numbers are ", int(num1)+int(num2))

except Exception as e:
    print(e)

print("This Line is very important and wanted to run this code or line so used try and except.")