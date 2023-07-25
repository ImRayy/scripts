import os
import sys

try:
    path = sys.argv[1]
except:
    path = input("Enter music path -> ")

for file in os.listdir(path):
    before = (f"{path}/{file}")
    x = file.split(" ")[2:]
    after = (f"{path}/{' '.join(x)}")
    os.rename(before, after)
