## Integrate our code OpenAI API

import os
from constant import openai_key

# from langchain_community import OpenAI
from langchain_openai import ChatOpenAI
from langchain import PromptTemplate
from langchain.chains import LLMChain, SimpleSequentialChain, SequentialChain
from langchain.memory import ConversationBufferMemory

import streamlit as st

os.environ['OPENAI_API_KEY'] = openai_key

# streamlit framework

st.title('Langchain Demo with OPENAI API')

input_text = st.text_input("Search the topic you want")

#Prompt templates

# first_input_prompt = PromptTemplate(
#                     input_variable=["name"],
#                     template ="Tell me about {name}"
# )

# second_input_prompt = PromptTemplate(
#                     input_variable=["person"],
#                     template ="when was {person} born")


third_input_prompt = PromptTemplate(
                    input_variable=["dob"],
                    template ="Mention 5 mejor event around {dob} in the world")

#Memory 

person_memory = ConversationBufferMemory(input_key='name', memory_key='chat_history')
dob_memory = ConversationBufferMemory(input_key='person', memory_key='chat_history')
descr_memory = ConversationBufferMemory(input_key='dob', memory_key='description_history')

## OPENAI LLMS
llm = ChatOpenAI(temperature =.8)
chain = LLMChain(llm=llm, PromptTemplate=first_input_prompt, verbose=True,output_key='person', memory='person_memory')
chain2 = LLMChain(llm=llm, PromptTemplate=second_input_prompt, verbose=True,output_key='dob', memory='dob_memory')
chain3 = LLMChain(llm=llm, PromptTemplate=third_input_prompt, verbose=True,output_key='dob', memory='description_memory')

# parent_chain = SimpleSequentialChain(chains=[chain,chain2], verbose=True) # it will genrate the final chain output
parent_chain = SequentialChain(chains=[chain,chain2,chain3], input_variable=['name'],
                               output_variable=['person','dob','description'], verbose=True, memory=person_memory)

if input_text:
    # st.write(chain.run(input_text))
    st.write(parent_chain({'name':input_text}))

    with st.expander('Person Name'):
        st.info(person_memory.buffer)

    with st.expander('Mejor Event'):
        st.info(descr_memory.buffer)


