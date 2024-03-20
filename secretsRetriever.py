import win32crypt
import binascii
import sys
import csv
import codecs
import base64
from difflib import *

def decrypt(password):
    #print(password)
    _, decrypted_password_string = win32crypt.CryptUnprotectData(binascii.unhexlify(password), None, None, None, 0)
    #print(decrypted_password_string.decode())
    return decrypted_password_string.decode("utf-16")


def main(list_of_secrets):
    path = 'C:\\users\\avelasquez\\.secrets.csv'
    with open(path, newline='') as csvfile:
        secrets = csv.reader(csvfile, delimiter=',')
        next(secrets)
        if len(list_of_secrets) == 1:
            for row in secrets:
                application = decrypt(row[0])
                if list_of_secrets[0] == application.lower():
                    password = decrypt(row[1])
                    return password
            #print(password)
        if len(list_of_secrets) == 2:
            for row in secrets:
                if row[2] != "":
                    application = decrypt(row[0])
                    username = decrypt(row[2])
                    if application.lower() == list_of_secrets[0] and username.lower() == list_of_secrets[1].lower():
                        password = decrypt(row[1])
                        return password
                else:
                    application = decrypt(row[0])
                    if application == list_of_secrets[0]:
                        password = decrypt(row[1])
                        return password



if __name__ == "__main__":
    arguments = []
    if len(sys.argv) ==2:
        arguments.append(sys.argv[1])
    elif len(sys.argv) == 3:
        arguments.append(sys.argv[1])
        arguments.append(sys.argv[2])
    else:
        print("Needs up to 2 arguments: Application then Username or just Application.")
        
    print(main(arguments))