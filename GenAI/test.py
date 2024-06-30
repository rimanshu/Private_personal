from constant import openai_key
import os

os.environ['OPENAI_API_KEY'] = openai_key

# from langchain_community.llms import OpenAI
# llms = OpenAI(model_name="gpt-3.5-turbo-instruct")

# name = llms("I want to open an Italian food restaurants. Suggest a fancy name for this")

# print(name)

from openai import OpenAI
client = OpenAI()

completion = client.chat.completions.create(
  model="gpt-3.5-turbo",
  messages=[
    {"role": "system", "content": "You are a poetic assistant, skilled in explaining complex programming concepts with creative flair."},
    {"role": "user", "content": "Compose a poem that explains the concept of recursion in programming."}
  ]
)

print(completion.choices[0].message)


-------------------------------------------------------------

# llama2 model code.

from langchain.llms import PromptTemplate
from langchain.llm import CTransformers

def getllama2response(input_text, no_words, blog_style): #blog_style means datascientist, resaercher etc
    llm= CTransformers(model='model/llama-2-7b-chat.ggmlv3.q8_0.bin',
                       model_type='llama2',
                       config={'max_new_token':256,
                               'temprature':0.01}
                       )
    
    prompt_template = """ write a blog for {blog_style} job profile for a topic {input_text} within {no_words} words."""

    prompt = PromptTemplate(input_variable=["blog_style","input_text",'no_words'], template= prompt_template)