import json

API_VALIDATION_JSON = 				{
			"Response": {
				"EntityHeaderDetails": [{
					"WorkType": "Write-Back",
					"SubType": "Write-Back",
					"Keyword": "",
					"Language": "English",
					"Status": "",
					"MappingField": "Customer_Name__c"
				}]
			}
		}

#print(API_VALIDATION_JSON)

with open(r'C:\Projects\TCA\tca_updated\tca_product_ml\TCA_Product_ML_Model\tca\config_files\entity_json\en.json',
		  encoding="utf-8") as lang_json:
	et_config_data = json.load(lang_json)

with open(r'C:\Projects\TCA\tca_updated\tca_product_ml\TCA_Product_ML_Model\tca\config_files\lang_map.json',
		  encoding="utf-8") as lang_json:
    lang_data=json.load(lang_json)


res_data_temp = API_VALIDATION_JSON.get(u"Response").get(u"EntityHeaderDetails")

def api_testing(res_data_temp):

    for i in res_data_temp:
        if not all(isinstance(k, str) for k in [i["WorkType"], i["SubType"], i[
                            "Keyword"], i["MappingField"], i["Language"], i["Status"]]):
            return ("Fields value in Json doesnt have string type")
            break

        if (len(i['WorkType']) <1) or (len(i['SubType']) <1) or (len(i['Keyword']) <1) or (len(i['Language']) <1) or (len(i['Status']) <1):
            return 'error'
            break

        if i["Status"] not in ["Accept", "Reject"]:
            print("Status is wrong")
            break

        if (i['WorkType'] != i['SubType']) :
            return ('WorkType is not same as SubType')
            break

        if i['Language'] not in lang_data.keys():
            return ('Language is not valid')
            break

        if i['Status'] == "Accept" and (len(i['MappingField']) <1):
            return ('Fill Mapping Field incase of Accept case')
            break

        if i['WorkType'] not in et_config_data.keys():
            return ('WorkType is not in Config file')
            break

        if i['MappingField'] not in et_config_data[i['WorkType']].keys():
            return ('Mapping is not valid')
            break

abcccc= api_testing(res_data_temp)

print(abcccc)