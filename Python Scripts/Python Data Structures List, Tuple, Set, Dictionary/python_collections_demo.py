list=[10,20,30,40]
list.append(50)
list.append(60)
print(list)
print(len(list))
list.extend([70,80,90,10])
print(list)
list.remove(50)
print(list)
print(list.count(10))
print(list.index(20))

list1=["prabha","gava","swe","reddy"]
print(list1)

tuple=(10,20,30,40,10)
print(tuple)
print(tuple.count(10))
print(len(tuple))
print("index=",list.index(20))
print("hash=",hash(tuple))

list2=[10,10.12,"aug",True]
print("list2=",list2)
#print("list hash =",hash(list2)) --TypeError: unhashable type: 'list'

set={10,20,30,40}
print("set=",set)
#set.append(50) --AttributeError: 'set' object has no attribute 'append

set.add(50)
print("set add=",set)
set.update({60,70,80})
print("set update=",set)
print(len(set))
#print(hash(set))--TypeError: unhashable type: 'set


*************OUTPUT ******************************************************
[10, 20, 30, 40, 50, 60]
6
[10, 20, 30, 40, 50, 60, 70, 80, 90, 10]
[10, 20, 30, 40, 60, 70, 80, 90, 10]
2
1
['prabha', 'gava', 'swe', 'reddy']
(10, 20, 30, 40, 10)
2
5
index= 1
hash= 4504601685887081076
list2= [10, 10.12, 'aug', True]
set= {40, 10, 20, 30}
set add= {40, 10, 50, 20, 30}
set update= {70, 40, 10, 80, 50, 20, 60, 30}
8

=== Code Execution Successful ===
