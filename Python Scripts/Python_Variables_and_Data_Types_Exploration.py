# Individual variable assignments
x = 5                       # int
name = "Alice"              # str
pi = 3.14                   # float
is_python = True            # bool
z = 1 + 2j                  # complex

print(x, name, pi, is_python, z)

# Multiple values assigned at once with different types
a, b, c = 1, 2.0, 'hello'   # int, float, str
print(a, b, c)

# Same value assigned to multiple variables
m = n = o = 42
print(m, n, o)

# Unpack a list
fruits = ["apple", "banana", "cherry", "date", "elderberry", "fig", "grape"]
f1, f2, f3, f4, f5, f6, f7 = fruits
print(f1, f2, f3, f4, f5, f6, f7)

# Unpack a tuple
person = ("John", 25, "Doctor")
p_name, p_age, p_profession = person
print(p_name, p_age, p_profession)

# Swapping variables
x, y = 10, 20
x, y = y, x
print(x, y)

# Additional variable types examples:
# range
r = range(3)
print(list(r))

# Dictionary
student = {"name": "Alice", "age": 21}
print(student)

# Set and frozenset
colors = {"red", "green", "blue"}
fcolors = frozenset(colors)
print(colors)
print(fcolors)

# Bytes and bytearray
b = b"Hello"
ba = bytearray(b)
print(b)
print(ba)

# Memoryview
mv = memoryview(b)
print(mv)

# NoneType
n = None
print(n)

# List slicing examples
print("Sliced fruits (index 1 to 4):", fruits[1:5])              # banana to elderberry
print("Sliced fruits start to index 3:", fruits[:4])             # apple to date
print("Sliced fruits from index 3 to end:", fruits[3:])          # date to grape
print("Sliced fruits with step 2:", fruits[::2])                 # every second fruit
print("Sliced fruits reversed:", fruits[::-1])                   # list reversed

# String slicing examples
print("Name sliced (index 1 to 3):", name[1:4])                   # lic
print("Name sliced start to 3:", name[:3])                        # Ali
print("Name sliced from 3 to end:", name[3:])                     # ce
print("Name reversed:", name[::-1])                              # ecilA

# Check types with type()
print(type(x), type(pi), type(z), type(name), type(is_python), type(fruits), type(student), type(b), type(n))



