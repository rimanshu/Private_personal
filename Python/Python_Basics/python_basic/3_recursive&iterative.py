def factorial_iterative(n):
    """This is factorial iterative function"""
    fac =1
    for i in range(n):
        fac = fac * (i+1)
    return fac

def factorial_recursive(n):
    """This is factorial recursive function"""

    if n ==1:
        return 1
    else:
        return n * factorial_recursive(n-1)

num12=int(input("Enter the number .... "))

result=factorial_iterative(num12)
resutl1=factorial_recursive(num12)

print("Factorial using Iterative method ....",result)

print("Factorial using Recursive method ....",resutl1)

## Function to print fibonacii series

def fibonaci_series(n):
    if n==1:
        return 0
    elif n==2:
        return 1
    else:
        return fibonaci_series(n-1) + fibonaci_series(n-2)

resutl12=fibonaci_series(num12)
print("Fibonacii series using Recursive method ....",resutl12)
