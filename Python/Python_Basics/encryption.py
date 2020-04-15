# # import json
# # from datetime import datetime
# # start_time = datetime.now()
# # print("Start time",start_time)
# # # do your work here
# # end_time = datetime.now()
# # print("End time",end_time)
# # print('Time Duration: {}'.format(end_time - start_time))
# # #str1=
# # #print(json.dumps(str1))
#
# from cryptography.fernet import Fernet
#
# AUTHENTICATOR_FILE_PATH = r'C:/Users/Rimanshu/Desktop/'
# KEY_NAME = '.sfkey'
#
# key = Fernet.generate_key()
# file0 = open(AUTHENTICATOR_FILE_PATH + KEY_NAME, "wb")
# file0.write(key)
# file0.close()
#
#
# def encrypt_password(password):
#     try:
#         fernet = Fernet(key)
#         token = fernet.encrypt(bytes(password, 'utf-8'))
#         print(token)
#     except Exception as e:
#         print(e)
#
#
# PASSWORD1 = 'coratca*999'
# # PASSWORD2 = ''
# # PASSWORD3 = ''
#
# encrypt_password(PASSWORD1)
# # encrypt_password(PASSWORD2)
# # encrypt_password(PASSWORD3)

a=(23,34)
print(a[1],type(str(a)))

#
# #b'gAAAAABeDtKPlSup2H8JDTfO--H6IpDFWB-cHq7qP3RoHQV9GlGIFhI57Hwdvq2ezwrIdt0VE-a53TrN4qFpBIbR8dXBVgw0qA=='