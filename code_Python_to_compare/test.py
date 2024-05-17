import time

# Convert hexadecimal numbers to integers
hex_num1 = 0xabcc
hex_num2 = 0xccdd

start_time = time.time()

# Perform multiplication
for i in range(1000000):
    result = hex_num1 * hex_num2

end_time = time.time()
elapsed_time = "{:0.9f}".format(end_time - start_time)

print("")
print("Multiplication result:",hex(hex_num1), " x ", hex(hex_num2), " = ", hex(result))
print("Multiplication time:", (elapsed_time), "us\n")
