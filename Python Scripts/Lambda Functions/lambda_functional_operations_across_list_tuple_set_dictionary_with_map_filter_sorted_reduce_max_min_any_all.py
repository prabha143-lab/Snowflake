from functools import reduce

# Lambda with List
numbers_list = [1, 2, 3, 4, 5]

doubled_list = list(map(lambda x: x * 2, numbers_list))
evens_list = list(filter(lambda x: x % 2 == 0, numbers_list))
sorted_desc_list = sorted(numbers_list, key=lambda x: -x)
sorted_by_square = sorted(numbers_list, key=lambda x: x ** 2)
sum_list = reduce(lambda a, b: a + b, numbers_list)
max_even = max(numbers_list, key=lambda x: x if x % 2 == 0 else -1)
min_odd = min(numbers_list, key=lambda x: x if x % 2 != 0 else float('inf'))
all_positive = all(map(lambda x: x > 0, numbers_list))
any_above_4 = any(map(lambda x: x > 4, numbers_list))

print("List Doubled:", doubled_list)
print("List Evens:", evens_list)
print("List Sorted Desc:", sorted_desc_list)
print("List Sorted by Square:", sorted_by_square)
print("List Sum (reduce):", sum_list)
print("List Max Even:", max_even)
print("List Min Odd:", min_odd)
print("List All Positive:", all_positive)
print("List Any Above 4:", any_above_4)
print(" ")

# Lambda with Tuple
numbers_tuple = (1, 2, 3, 4, 5)

tripled_tuple = tuple(map(lambda x: x * 3, numbers_tuple))
odds_tuple = tuple(filter(lambda x: x % 2 != 0, numbers_tuple))
sorted_tripled_tuple = tuple(sorted(tripled_tuple, key=lambda x: x))
sorted_odds_tuple = tuple(sorted(odds_tuple, key=lambda x: -x))
sum_tuple = reduce(lambda a, b: a + b, numbers_tuple)
max_even_tuple = max(numbers_tuple, key=lambda x: x if x % 2 == 0 else -1)
min_odd_tuple = min(numbers_tuple, key=lambda x: x if x % 2 != 0 else float('inf'))
all_less_than_10 = all(map(lambda x: x < 10, numbers_tuple))
any_equal_3 = any(map(lambda x: x == 3, numbers_tuple))

print("Tuple Tripled:", tripled_tuple)
print("Tuple Odds:", odds_tuple)
print("Tuple Tripled Sorted Asc:", sorted_tripled_tuple)
print("Tuple Odds Sorted Desc:", sorted_odds_tuple)
print("Tuple Sum (reduce):", sum_tuple)
print("Tuple Max Even:", max_even_tuple)
print("Tuple Min Odd:", min_odd_tuple)
print("Tuple All < 10:", all_less_than_10)
print("Tuple Any == 3:", any_equal_3)
print(" ")

# Lambda with Set
numbers_set = {1, 2, 3, 4, 5}

squared_set = set(map(lambda x: x ** 2, numbers_set))
filtered_set = set(filter(lambda x: x > 10, squared_set))
sorted_squared_set = sorted(squared_set, key=lambda x: x)
sorted_filtered_set = sorted(filtered_set, key=lambda x: -x)
sum_set = reduce(lambda a, b: a + b, squared_set)
max_square = max(squared_set, key=lambda x: x)
min_square = min(squared_set, key=lambda x: x)
all_even_squares = all(map(lambda x: x % 2 == 0, squared_set))
any_square_above_20 = any(map(lambda x: x > 20, squared_set))

print("Set Squared:", squared_set)
print("Set Filtered >10:", filtered_set)
print("Set Squared Sorted Asc:", sorted_squared_set)
print("Set Filtered Sorted Desc:", sorted_filtered_set)
print("Set Sum (reduce):", sum_set)
print("Set Max Square:", max_square)
print("Set Min Square:", min_square)
print("Set All Even Squares:", all_even_squares)
print("Set Any Square > 20:", any_square_above_20)
print(" ")

# Lambda with Dictionary (Numeric Values)
scores_dict = {
    101: 45,
    102: 78,
    103: 88,
    104: 59,
    105: 92
}

doubled_scores = {k: (lambda x: x * 2)(v) for k, v in scores_dict.items()}
passed_scores = dict(filter(lambda item: item[1] >= 60, scores_dict.items()))
sorted_scores_asc = dict(sorted(scores_dict.items(), key=lambda item: item[1]))
sorted_scores_desc = dict(sorted(scores_dict.items(), key=lambda item: -item[1]))
total_score = reduce(lambda acc, item: acc + item[1], scores_dict.items(), 0)
max_score = max(scores_dict.items(), key=lambda item: item[1])
min_score = min(scores_dict.items(), key=lambda item: item[1])
all_passed = all(map(lambda item: item[1] >= 60, scores_dict.items()))
any_above_90 = any(map(lambda item: item[1] > 90, scores_dict.items()))
bonus_scores = {k: (lambda x: x + 5)(v) for k, v in scores_dict.items()}
sorted_bonus_desc = dict(sorted(bonus_scores.items(), key=lambda item: -item[1]))

print("Doubled Scores:", doubled_scores)
print("Passed Scores:", passed_scores)
print("Sorted Scores Asc:", sorted_scores_asc)
print("Sorted Scores Desc:", sorted_scores_desc)
print("Total Score (reduce):", total_score)
print("Max Score:", max_score)
print("Min Score:", min_score)
print("All Passed:", all_passed)
print("Any Above 90:", any_above_90)
print("Bonus Scores:", bonus_scores)
print("Bonus Scores Sorted Desc:", sorted_bonus_desc)



***********************OUTPUT****************************
List Doubled: [2, 4, 6, 8, 10]
List Evens: [2, 4]
List Sorted Desc: [5, 4, 3, 2, 1]
List Sorted by Square: [1, 2, 3, 4, 5]
List Sum (reduce): 15
List Max Even: 4
List Min Odd: 1
List All Positive: True
List Any Above 4: True
 
Tuple Tripled: (3, 6, 9, 12, 15)
Tuple Odds: (1, 3, 5)
Tuple Tripled Sorted Asc: (3, 6, 9, 12, 15)
Tuple Odds Sorted Desc: (5, 3, 1)
Tuple Sum (reduce): 15
Tuple Max Even: 4
Tuple Min Odd: 1
Tuple All < 10: True
Tuple Any == 3: True
 
Set Squared: {1, 4, 9, 16, 25}
Set Filtered >10: {16, 25}
Set Squared Sorted Asc: [1, 4, 9, 16, 25]
Set Filtered Sorted Desc: [25, 16]
Set Sum (reduce): 55
Set Max Square: 25
Set Min Square: 1
Set All Even Squares: False
Set Any Square > 20: True
 
Doubled Scores: {101: 90, 102: 156, 103: 176, 104: 118, 105: 184}
Passed Scores: {102: 78, 103: 88, 105: 92}
Sorted Scores Asc: {101: 45, 104: 59, 102: 78, 103: 88, 105: 92}
Sorted Scores Desc: {105: 92, 103: 88, 102: 78, 104: 59, 101: 45}
Total Score (reduce): 362
Max Score: (105, 92)
Min Score: (101, 45)
All Passed: False
Any Above 90: True
Bonus Scores: {101: 50, 102: 83, 103: 93, 104: 64, 105: 97}
Bonus Scores Sorted Desc: {105: 97, 103: 93, 102: 83, 104: 64, 101: 50}

=== Code Execution Successful ===