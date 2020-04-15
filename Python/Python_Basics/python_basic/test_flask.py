from flask import Flask,request,jsonify
import requests
import json
app=Flask(__name__)

@app.route("/salesforce",methods=['POST'])
def sales_force_fun():
    input_json=json.loads(request.data)
    print("inside sales force found this input ::")
    print(input_json)
    if isinstance(input_json,dict):
        return jsonify({"result":"Successfull"})
    else:
        return jsonify({"result":"Unsuccessfull"})

if __name__ =="__main__":
    from werkzeug.serving import run_simple
    run_simple('localhost', 5050,app)
