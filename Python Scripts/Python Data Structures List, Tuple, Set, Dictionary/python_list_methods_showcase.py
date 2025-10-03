list1=[12,13,14,15]
print("list1 =>",list1)
list1.append(16)
print("list1 append =>",list1)
list1.extend([17,18,19])
print("lsit1 extend =>",list1)
list1.extend((21,20,21))
print("list1 extend tuple =>",list1)
#list.reverse(1) --TypeError: list.reverse() takes no arguments (1 given)

list1.reverse()
print("list1 reverse =>",list1)
list1.count(21)
#Counts how many times 21 appears in the list (but discards the result)
#Prints the entire list again—not the count

print("list1 count =>",list1)
print("list1 count =>",list1.count(21))

# Remove duplicates using set (unordered)
unique_list = list(set(list1))
print("list1 set =>", unique_list)


**************OUTPUT******************

list1 => [12, 13, 14, 15]
list1 append => [12, 13, 14, 15, 16]
lsit1 extend => [12, 13, 14, 15, 16, 17, 18, 19]
list1 extend tuple => [12, 13, 14, 15, 16, 17, 18, 19, 21, 20, 21]
list1 reverse => [21, 20, 21, 19, 18, 17, 16, 15, 14, 13, 12]
list1 count => [21, 20, 21, 19, 18, 17, 16, 15, 14, 13, 12]
list1 count => 2
list1 set => [12, 13, 14, 15, 16, 17, 18, 19, 20, 21]

=== Code Execution Successful ===