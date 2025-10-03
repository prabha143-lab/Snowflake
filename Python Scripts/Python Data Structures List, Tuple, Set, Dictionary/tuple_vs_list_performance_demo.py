# ✅ Tuple vs List: Performance, Memory, and Hashability Demo

# Create a tuple with 10 million elements
big_tuple = tuple(range(10_000_000))
print("✅ Tuple created with", len(big_tuple), "elements")

# Create a list with 10 million elements
big_list = list(range(10_000_000))
print("✅ List created with", len(big_list), "elements")

# ✅ Hashability check
try:
    hash(big_tuple)
    print("Tuple is hashable ✅")
except TypeError:
    print("Tuple is not hashable ❌")

try:
    hash(big_list)
    print("List is hashable ✅")
except TypeError:
    print("List is not hashable ❌")

# ✅ Memory usage (requires sys module)
try:
    import sys
    print("Memory used by tuple:", sys.getsizeof(big_tuple), "bytes")
    print("Memory used by list :", sys.getsizeof(big_list), "bytes")
except ImportError:
    print("Module 'sys' not available for memory check ❌")

# ✅ Access speed benchmark (requires time module)
try:
    import time
    start = time.time()
    _ = big_tuple[9999999]
    print("Tuple access time:", time.time() - start, "seconds")

    start = time.time()
    _ = big_list[9999999]
    print("List access time :", time.time() - start, "seconds")
except ImportError:
    print("Module 'time' not available for access speed check ❌")



*********************OUTPUT***********************

C:\Pythontestfiles>python tuple_vs_list_performance_demo.py
✅ Tuple created with 10000000 elements
✅ List created with 10000000 elements
Tuple is hashable ✅
List is not hashable ❌
Memory used by tuple: 80000040 bytes
Memory used by list : 80000056 bytes
Tuple access time: 7.152557373046875e-06 seconds
List access time : 5.0067901611328125e-06 seconds

C:\Pythontestfiles>