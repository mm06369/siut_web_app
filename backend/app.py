from flask import Flask, request
import os
import pandas as pd
import openai
from sqlalchemy import create_engine
from sqlalchemy import text

app = Flask(__name__)

def load_column_names():
    column_names = {
        'Patient_Reference' : '',
        'ServiceID' : '',
        'Gender': '',
        'DOB': '',
        'Age': '',
        'City': '',
        'Visit_ID': '',
        'VisitType': '',
        'VisitDateIn': '',
        'VisitDateOut': '',
        'Diagnose_Type': '',
        'Diagnosis_ID': '',
        'Created_By': '',
        'Created_DtTm': '',
        'Procedure_Type': '',
        'Procedure_ID': '',
        'Procedure_Date': '',
        'Created_By': '',
        'Created_DtTm': '',
        'Other_Code_Type': '',
        'Code': '',
        'Created_DtTm': '',
    }

    return pd.DataFrame(column_names, index=[0])


@app.route('/get_query')
def getQuery():
    plain_text = request.args.get('plain_text')
    df = load_column_names()
    prompt = '''### sqlite SQL table, with its properties:
            #
            # Medical({})
            #
            '''.format(",".join(str(x) for x in df.columns))
    nlp_text = plain_text
    definition = prompt
    query_init_string = f"### A query to answer: {plain_text}\nSELECT"
    openai.api_key = "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"
    response = openai.Completion.create(model="text-davinci-003",prompt=definition+query_init_string,temperature=0,max_tokens=150,top_p=1.0,frequency_penalty=0.0,presence_penalty=0.0,stop=["#", ";"])
    query = response["choices"][0]["text"]
    if query.startswith(" "):
        query = "Select"+ query
    return query

if __name__ == '__main__':
    app.run(debug=True)
