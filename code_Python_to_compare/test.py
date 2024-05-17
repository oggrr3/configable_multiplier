import time

# Convert hexadecimal numbers to integers
hex_num1 = 0xabcd
hex_num2 = 0x123456

start_time = time.time()

# Perform multiplication
for i in range(1000000):
    result = hex_num1 * hex_num2

end_time = time.time()
elapsed_time = "{:0.9f}".format(end_time - start_time)

print("Multiplication result:", hex(result))
print("Multiplication time:", (elapsed_time), "seconds")
