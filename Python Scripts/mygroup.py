import pandas as pd

# File paths
customer_file = 'C:/Pythontestfiles/customers.csv'
transaction_file = 'C:/Pythontestfiles/transactions.csv'

# Read CSV files
customers = pd.read_csv(customer_file)
transactions = pd.read_csv(transaction_file)

# Merge on customer_id
merged = pd.merge(transactions, customers, on='customer_id')

# Compute total spend per customer
total_spend = merged.groupby(['customer_id', 'name'])['amount'].sum().reset_index()

# Display result
print("💰 Total Spend Per Customer:")
print(total_spend)
