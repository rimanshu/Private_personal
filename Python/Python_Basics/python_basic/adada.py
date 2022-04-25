# import json,log
# from jsonschema import validate
#
# schema = {
#     "title": "Update_API_Vaidation",
#     "type": "object",
#     "required": [
#         "WorkType",
#         "SubType",
#         "Keyword",
#         "Language",
#         "Status",
#         "MappingField"
#     ],
#     "properties": {
#         "WorkType": {
#             "type": "string",
#             "description": "Worktype",
#             "minLength": 1,
#             "error_msg": "error"
#         },
#         "description": {
#             "type": "string",
#             "description": "Short description",
#             "minLength": 1,
#             "error_msg": "error"
#         }
#     }
# }
#
# data = {
#     "author": "Jerakin",
#     "description": ""
# }
#
# try:
#     validate(instance=data, schema=schema)
# except Exception as e:
#         return 'error'
#
# print(validate)