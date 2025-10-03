# List creation using constructor
list1 = list([12, 13, 14, 15])
print("list1 =>", list1)
print("data type of list1 =>", type(list1))

# List creation using literal
list2 = [12, 13, 14, 15]
print("list2 =>", list2)
print("data type of list2 =>", type(list2))

# Compare values and types
print("compare list1 and list2 =>", list1 == list2)
print("compare type(list1) and type(list2) =>", type(list1) == type(list2))

# Tuple creation using constructor
tuple1 = tuple((12, 13, 14, 15))
print("tuple1 =>", tuple1)
print("data type of tuple1 =>", type(tuple1))

# Tuple creation using literal
tuple2 = (12, 13, 14, 15)
print("tuple2 =>", tuple2)
print("data type of tuple2 =>", type(tuple2))

# Compare values and types
print("compare tuple1 and tuple2 =>", tuple1 == tuple2)
print("compare type(tuple1) and type(tuple2) =>", type(tuple1) == type(tuple2))

# Tuple from list
tuple3 = tuple([12, 13, 14, 15])
print("tuple3 =>", tuple3)

# List for comparison
tuple4 = [12, 13, 14, 15]
print("tuple4 =>", tuple4)

# ❌ Overwriting built-in tuple
tuple = [12, 13, 14, 15]
print("tuple =>", tuple)

# ❌ This will fail: TypeError: 'list' object is not callable
try:
    converted = tuple([5, 6, 7])
    print("converted =>", converted)
except TypeError as e:
    print("ERROR! TypeError:", e)

# ✅ Restore built-in tuple
del tuple
converted = tuple([5, 6, 7])
print("converted after del =>", converted)


***********************OUTPUT ***********************

ERROR!
list1 => [12, 13, 14, 15]
data type of list1 => <class 'list'>
list2 => [12, 13, 14, 15]
data type of list2 => <class 'list'>
compare list1 and list2 => True
compare type(list1) and type(list2) => True
tuple1 => (12, 13, 14, 15)
data type of tuple1 => <class 'tuple'>
tuple2 => (12, 13, 14, 15)
data type of tuple2 => <class 'tuple'>
compare tuple1 and tuple2 => True
compare type(tuple1) and type(tuple2) => True
tuple3 => (12, 13, 14, 15)
tuple4 => [12, 13, 14, 15]
tuple => [12, 13, 14, 15]
ERROR! TypeError: 'list' object is not callable
converted after del => (5, 6, 7)

=== Code Execution Successful ===
