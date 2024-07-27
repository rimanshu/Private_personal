import google.generativeai as genai
from dotenv import load_dotenv
import os
import streamlit as st

# Load your API key from environment variables
load_dotenv()

os.getenv("AIzaSyDEUTYKIk1ccdeIxjOgqySjDXi8ACF0d0c")
genai.configure(api_key=os.getenv("AIzaSyDEUTYKIk1ccdeIxjOgqySjDXi8ACF0d0c"))

credential_path = "C:\Users\riman\VSCode\GenAI_Projects\GenAI\Krish_GenAI\Gemini\model-augury-425401-r0-6775bf279613.json"
os.environ['GOOGLE_APPLICATION_CREDENTIALS'] = credential_path

## Function to load OpenAI model and get respones

def get_gemini_response(question):
    model = genai.GenerativeModel('gemini-pro')
    response = model.generate_content(question)
    return response.text

##initialize our streamlit app

st.set_page_config(page_title="Q&A Demo")

st.header("Gemini Application")

input=st.text_input("Input: ",key="input")


submit=st.button("Ask the question")

## If ask button is clicked

if submit:
    
    response=get_gemini_response(input)
    st.subheader("The Response is")
    st.write(response)
