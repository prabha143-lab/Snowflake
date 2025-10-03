# ✅ Tuples are immutable and hashable, so they can be used as dictionary keys
my_tuple = (1, 2, 3)
my_dict = {my_tuple: "I am a key"}  # ✅ Works because tuple is hashable
print(my_dict)  # Output: {(1, 2, 3): 'I am a key'}

# ❌ Lists are mutable and unhashable, so they cannot be used as dictionary keys
my_list = [1, 2, 3]
my_dict = {my_list: "I am a key"}   # ❌ Raises TypeError: unhashable type: 'list'


****************OUTPUT*****************


{(1, 2, 3): 'I am a key'}
ERROR!
Traceback (most recent call last):
  File "<main.py>", line 8, in <module>
TypeError: unhashable type: 'list'

=== Code Exited With Errors ===