# ✅ Shadowing and restoring built-in types in Python

# Shadowing built-in tuple
tuple = [1, 2, 3, 4]  # Overwrites built-in tuple()
print("tuple =>", tuple)

del tuple  # Restores access to built-in tuple()
tuple1 = tuple([5, 6, 7])
print("tuple1 =>", tuple1)

# Shadowing built-in list
list = (1, 2, 3, 4)  # Overwrites built-in list()
print("list =>", list)

del list  # Restores access to built-in list()
list1 = list([5, 6, 7])
print("list1 =>", list1)

# Shadowing built-in set
set = {1, 2, 3}  # Overwrites built-in set()
print("set =>", set)

del set  # Restores access to built-in set()
set1 = set([4, 5, 6])
print("set1 =>", set1)

# Shadowing built-in dict
dict = {"a": 1, "b": 2}  # Overwrites built-in dict()
print("dict =>", dict)

del dict  # Restores access to built-in dict()
dict1 = dict([("x", 10), ("y", 20)])
print("dict1 =>", dict1)

# Additional shadowing examples for set
set = [1, 2, 3]  # Overwrites built-in set again
print("set =>", set)

set = (1, 2, 3)  # Overwrites built-in set again
print("set =>", set)

del set  # Final restore
set2 = set([7, 8, 9])
print("set2 =>", set2)



*********************OUTPUT ************************

tuple => [1, 2, 3, 4]
tuple1 => (5, 6, 7)
list => (1, 2, 3, 4)
list1 => [5, 6, 7]
set => {1, 2, 3}
set1 => {4, 5, 6}
dict => {'a': 1, 'b': 2}
dict1 => {'x': 10, 'y': 20}
set => [1, 2, 3]
set => (1, 2, 3)
set2 => {8, 9, 7}

=== Code Execution Successful ===
