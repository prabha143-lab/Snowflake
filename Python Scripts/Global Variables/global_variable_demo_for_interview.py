# Filename: global_variable_demo_for_interview.py

# ✅ Declare global variable inside a function
def set_global_value():
    global shared_data  # Declare as global
    shared_data = "Hello from global scope!"  # Assign value
    print("Inside set_global_value() =>", shared_data)

# ✅ Access global variable from another function
def use_global_value():
    print("Inside use_global_value() =>", shared_data)

# ✅ Call both functions
set_global_value()     # Initializes the global variable
print(" ")
use_global_value()     # Accesses the global variable


**********************OUTPUT*****************

Inside set_global_value() => Hello from global scope!
 
Inside use_global_value() => Hello from global scope!

=== Code Execution Successful ===