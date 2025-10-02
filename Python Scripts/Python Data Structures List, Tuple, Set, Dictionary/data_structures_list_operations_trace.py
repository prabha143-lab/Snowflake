# Initial list
my_list = [30, 10, 50, 20, 80]
print("Original list:", my_list)

# Step 1️⃣ pop(2) — removes item at index 2 (third element: 50)
popped = my_list.pop(2)
print("After pop(2):", my_list)
print("Popped value:", popped)  # Expected: 50

# Step 2️⃣ append(40) — adds one item at the end
my_list.append(40)
print("After append(40):", my_list)

# Step 3️⃣ extend([60, 70]) — adds multiple items
my_list.extend([60, 70])
print("After extend([60, 70]):", my_list)

# Step 4️⃣ remove(10) — deletes first occurrence of value 10
my_list.remove(10)
print("After remove(10):", my_list)

# Step 5️⃣ pop(2) — removes item at index 2 (third element: 80)
popped = my_list.pop(2)
print("After pop(2):", my_list)
print("Popped value:", popped)  # Expected: 80

# Step 6️⃣ sort() — sorts in ascending order
my_list.sort()
print("After sort():", my_list)

# Step 7️⃣ reverse() — reverses the list
my_list.reverse()
print("After reverse():", my_list)



**************************OUTPUT *******************

Original list: [30, 10, 50, 20, 80]
After pop(2): [30, 10, 20, 80]
Popped value: 50
After append(40): [30, 10, 20, 80, 40]
After extend([60, 70]): [30, 10, 20, 80, 40, 60, 70]
After remove(10): [30, 20, 80, 40, 60, 70]
After pop(2): [30, 20, 40, 60, 70]
Popped value: 80
After sort(): [20, 30, 40, 60, 70]
After reverse(): [70, 60, 40, 30, 20]

=== Code Execution Successful ===