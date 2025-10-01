# List
fruits = ['apple', 'banana', 'cherry']
print("List:")
for i, fruit in enumerate(fruits):
    print(i, fruit)

# Tuple
colors = ('red', 'green', 'blue')
print("\nTuple:")
for i, color in enumerate(colors):
    print(i, color)

# Set (unordered)
animals = {'cat', 'dog', 'elephant'}
print("\nSet:")
for i, animal in enumerate(animals):
    print(i, animal)

# Dictionary (use .items() for key-value pairs)
student_scores = {'Alice': 85, 'Bob': 90, 'Charlie': 78}
print("\nDictionary (items):")
for i, (name, score) in enumerate(student_scores.items()):
    print(i, name, score)

print("\nDictionary (keys):")
for i, name in enumerate(student_scores.keys()):
    print(i, name)

print("\nDictionary (values):")
for i, score in enumerate(student_scores.values()):
    print(i, score)
