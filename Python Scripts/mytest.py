import pandas as pd

# Read the CSV file
df = pd.read_csv('employees.csv')

# Display the first few rows
print("📋 Full Data:")
print(df)

# 🔍 Filter: Employees in Engineering department
engineering_emps = df[df['department'] == 'Engineering']
print("\n👷 Engineering Employees:")
print(engineering_emps)

# 📊 Aggregation: Average salary by department
avg_salary = df.groupby('department')['salary'].mean()
print("\n💰 Average Salary by Department:")
print(avg_salary)

# 🧮 Transformation: Add a new column for bonus (10% of salary)
df['bonus'] = df['salary'] * 0.10
print("\n🎁 Data with Bonus Column:")
print(df)
