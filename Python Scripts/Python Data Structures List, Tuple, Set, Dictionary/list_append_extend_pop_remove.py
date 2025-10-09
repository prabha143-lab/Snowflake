list =[1,2,-1,3,8]
#print(list(0)) --TypeError: 'list' object is not callable

#print("list =>",list[0,1])--TypeError: list indices must be integers or slices, not tuple

print("list =>",list[0],list[1])
print("list =>",[list[0],list[1]])
print("list =>",list[0:2])
list.append(9)
print("list.append =>",list)
list.extend([11,13])
print("list.extend=>",list)
list.pop(1)
print("list.pop =>",list)
list.pop(-1)
print("list.pop =>",list)
#list.pop(1,3)
#print("list.pop =>",list) #TypeError: pop expected at most 1 argument, got 2

#list.remove(1,3)
#print("list.remove =>",list)--TypeError: list.remove() takes exactly one argument (2 given)
list.remove(11)
print("list.remove =>",list)

list.extend(range(20,30))
print("list.extend(range) =>",list)

for i in range(31,40):
    list.append(i)
    print("After looped append =>", list)
print(" ")
print("After looped append =>", list)



**********************OUTPUT ***************************

list => 1 2
list => [1, 2]
list => [1, 2]
list.append => [1, 2, -1, 3, 8, 9]
list.extend=> [1, 2, -1, 3, 8, 9, 11, 13]
list.pop => [1, -1, 3, 8, 9, 11, 13]
list.pop => [1, -1, 3, 8, 9, 11]
list.remove => [1, -1, 3, 8, 9]
list.extend(range) => [1, -1, 3, 8, 9, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29]
After looped append => [1, -1, 3, 8, 9, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 31]
After looped append => [1, -1, 3, 8, 9, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 31, 32]
After looped append => [1, -1, 3, 8, 9, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 31, 32, 33]
After looped append => [1, -1, 3, 8, 9, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 31, 32, 33, 34]
After looped append => [1, -1, 3, 8, 9, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 31, 32, 33, 34, 35]
After looped append => [1, -1, 3, 8, 9, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 31, 32, 33, 34, 35, 36]
After looped append => [1, -1, 3, 8, 9, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 31, 32, 33, 34, 35, 36, 37]
After looped append => [1, -1, 3, 8, 9, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 31, 32, 33, 34, 35, 36, 37, 38]
After looped append => [1, -1, 3, 8, 9, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 31, 32, 33, 34, 35, 36, 37, 38, 39]
 
After looped append => [1, -1, 3, 8, 9, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 31, 32, 33, 34, 35, 36, 37, 38, 39]

=== Code Execution Successful ===