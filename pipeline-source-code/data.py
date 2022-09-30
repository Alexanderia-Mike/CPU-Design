data = "0.982 ± 0.004 0.975 ± 0.004 0.969 ± 0.004 0.963 ± 0.004 0.953 ± 0.004 0.953 ± 0.004 0.950 ± 0.004 0.950 ± 0.004 0.967 ± 0.004 0.960 ± 0.004 0.966 ± 0.004 0.975 ± 0.004 0.982 ± 0.004 0.988 ± 0.004 0.991 ± 0.004 0.991 ± 0.004 0.991 ± 0.004 0.982 ± 0.004"
original_data_str = data.split()
print(original_data_str)

data_list = []
for data_str in original_data_str:
    if data_str != '±':
        data_list.append(float(data_str))


flag = 0
for i in data_list:
    flag = flag + 1
    if flag % 2 == 0:
        print(i)
