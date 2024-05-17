import re
from tabulate import tabulate

def twos_complement(hexstr, bits):
    value = int(hexstr, 16)
    if value & (1 << (bits - 1)):
        value -= 1 << bits
    return value

# Open the file
with open("test_for_multiplication_IP_FPGA_text.txt", "r") as f:
    f.readline()  # Read the title line
    number_faile = 0
    results = []

    for i in range(0, 100):
        txt = f.readline()
        temp = re.findall(r'\b\d+\b|\b\w+\b', txt)
        stt = int(temp[0], 10)
        mode = int(temp[1], 10)
        if mode == 10:
            a = twos_complement(temp[2], 16)
            b = twos_complement(temp[3], 16)
            product_soc = twos_complement(temp[4], 32)
            a_hex = temp[2]
            b_hex = temp[3]
            product_soc_hex = temp[4]
            if a * b == product_soc:
                results.append([stt, "CORRECT", a_hex, b_hex, product_soc_hex, a, b, product_soc, ""])
            else:
                results.append([stt, "INCORRECT", a_hex, b_hex, product_soc_hex, a, b, product_soc, a * b])
                number_faile += 1
        elif mode == 0:
            a = twos_complement(temp[2], 8)
            b = twos_complement(temp[3], 8)
            product_soc = twos_complement(temp[4], 32)
            a_hex = temp[2]
            b_hex = temp[3]
            product_soc_hex = temp[4]
            if a * b == product_soc:
                results.append([stt, "CORRECT", a_hex, b_hex, product_soc_hex, a, b, product_soc, ""])
            else:
                results.append([stt, "INCORRECT", a_hex, b_hex, product_soc_hex, a, b, product_soc, a * b])
                number_faile += 1
        elif mode == 1:
            pairs_a = re.findall(r'\w{2}', temp[2])
            pairs_b = re.findall(r'\w{2}', temp[3])
            pairs_product = re.findall(r'\w{4}', temp[4])
            a15_8 = twos_complement(pairs_a[0], 8)
            b15_8 = twos_complement(pairs_b[0], 8)
            product_soc31_16 = twos_complement(pairs_product[0], 16)
            a7_0 = twos_complement(pairs_a[1], 8)
            b7_0 = twos_complement(pairs_b[1], 8)
            product_soc15_0 = twos_complement(pairs_product[1], 16)
            if (a15_8 * b15_8 == product_soc31_16) and (a7_0 * b7_0 == product_soc15_0):
                results.append([stt, "CORRECT", pairs_a[0], pairs_b[0], pairs_product[0], a15_8, b15_8, product_soc31_16, ""])
                results.append([stt, "CORRECT", pairs_a[1], pairs_b[1], pairs_product[1], a7_0, b7_0, product_soc15_0, ""])
            else:
                results.append([stt, "INCORRECT", pairs_a[0], pairs_b[0], pairs_product[0], a15_8, b15_8, product_soc31_16, a15_8 * b15_8])
                results.append([stt, "INCORRECT", pairs_a[1], pairs_b[1], pairs_product[1], a7_0, b7_0, product_soc15_0, a7_0 * b7_0])
                number_faile += 1

# Define headers and print the table
headers = ["STT", "Status", "A (Hex)", "B (Hex)", "Product_SOC (Hex)", "A (Dec)", "B (Dec)", "Product_SOC (Dec)", "Expected Product (Dec)"]
print(tabulate(results, headers, tablefmt="grid"))
print(f"Chay 100 mau: So truong hop sai la: {number_faile}")
