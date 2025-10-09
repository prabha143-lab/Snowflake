
# ✅ Initialize list
my_list = [1, 2, -1, 3, 8]

# ❌ Invalid operations (commented for clarity)
# print(my_list(0))              # TypeError: 'list' object is not callable
# print("my_list =>", my_list[0,1]) # TypeError: list indices must be integers or slices, not tuple

# ✅ Accessing elements
print("my_list =>", my_list[0], my_list[1])         # Individual elements
print("my_list =>", [my_list[0], my_list[1]])       # As sublist
print("my_list =>", my_list[0:2])                   # Slice

# ✅ Adding elements
my_list.append(9)
print("my_list.append =>", my_list)

my_list.extend([11, 13])
print("my_list.extend =>", my_list)

# ✅ Removing elements
my_list.pop(1)                                # Removes element at index 1
print("my_list.pop =>", my_list)

my_list.pop(-1)                               # Removes last element
print("my_list.pop =>", my_list)

# ❌ Invalid removals (commented for clarity)
# my_list.pop(1,3)                            # TypeError: pop expected at most 1 argument
# my_list.remove(1,3)                         # TypeError: remove() takes exactly one argument

my_list.remove(11)                            # Removes value 11
print("my_list.remove =>", my_list)

# ✅ Bulk additions using range
my_list.extend(range(20, 30))
print("my_list.extend(range) =>", my_list)

# ✅ Loop-based append with progress tracking
for i in range(31, 40):
    my_list.append(i)
    print(f"Appended {i} =>", my_list)

# ✅ Final snapshot after loop
print("\nFinal list after looped append =>", my_list)

# ✅ Add final batch using +=
my_list += [41, 42, 43]
print("\nmy_list + =>", my_list)

# ✅ Remove multiple elements by value (refactored for clarity)
values_to_remove = [3, 9, 20, 42]
my_list = [item for item in my_list if item  not in values_to_remove]
print(f"\nRemoved values {values_to_remove} => {my_list}")

# ✅ Remove multiple elements by index slice
del my_list[2:5]  # Removes elements at index 2, 3, 4
print("\nRemoved by index slice [2:5] =>", my_list)

# ✅ Remove by condition (e.g., remove all odd numbers)
my_list = [item for item in my_list if item % 2 == 0]
print("\nRemoved all odd numbers =>", my_list)

# ✅ Functional style removal (e.g., keep values < 35)
my_list = list(filter(lambda item: item < 35, my_list))
print("\nFiltered values < 35 =>", my_list)


*****************************OUTPUT *********************************************

my_list => 1 2
my_list => [1, 2]
my_list => [1, 2]
my_list.append => [1, 2, -1, 3, 8, 9]
my_list.extend => [1, 2, -1, 3, 8, 9, 11, 13]
my_list.pop => [1, -1, 3, 8, 9, 11, 13]
my_list.pop => [1, -1, 3, 8, 9, 11]
my_list.remove => [1, -1, 3, 8, 9]
my_list.extend(range) => [1, -1, 3, 8, 9, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29]
Appended 31 => [1, -1, 3, 8, 9, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 31]
Appended 32 => [1, -1, 3, 8, 9, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 31, 32]
Appended 33 => [1, -1, 3, 8, 9, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 31, 32, 33]
Appended 34 => [1, -1, 3, 8, 9, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 31, 32, 33, 34]
Appended 35 => [1, -1, 3, 8, 9, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 31, 32, 33, 34, 35]
Appended 36 => [1, -1, 3, 8, 9, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 31, 32, 33, 34, 35, 36]
Appended 37 => [1, -1, 3, 8, 9, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 31, 32, 33, 34, 35, 36, 37]
Appended 38 => [1, -1, 3, 8, 9, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 31, 32, 33, 34, 35, 36, 37, 38]
Appended 39 => [1, -1, 3, 8, 9, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 31, 32, 33, 34, 35, 36, 37, 38, 39]

Final list after looped append => [1, -1, 3, 8, 9, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 31, 32, 33, 34, 35, 36, 37, 38, 39]

my_list + => [1, -1, 3, 8, 9, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 31, 32, 33, 34, 35, 36, 37, 38, 39, 41, 42, 43]

Removed values [3, 9, 20, 42] => [1, -1, 8, 21, 22, 23, 24, 25, 26, 27, 28, 29, 31, 32, 33, 34, 35, 36, 37, 38, 39, 41, 43]

Removed by index slice [2:5] => [1, -1, 23, 24, 25, 26, 27, 28, 29, 31, 32, 33, 34, 35, 36, 37, 38, 39, 41, 43]

Removed all odd numbers => [24, 26, 28, 32, 34, 36, 38]

Filtered values < 35 => [24, 26, 28, 32, 34]

=== Code Execution Successful ===