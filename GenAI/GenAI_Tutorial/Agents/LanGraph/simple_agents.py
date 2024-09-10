import streamlit as st
from langchain.chat_models import ChatOpenAI
from langchain.prompts import ChatPromptTemplate
from langchain.schema import BaseMessage, HumanMessage, AIMessage
from langgraph.graph import Graph
from typing import TypedDict, Annotated, Sequence
import os

# Set your OpenAI API key
os.environ["OPENAI_API_KEY"] = "your-api-key-here"

# Define the state
class AgentState(TypedDict):
    messages: Annotated[Sequence[BaseMessage], "The messages in the conversation"]
    next: str

# Define the nodes
def human(state):
    human_input = state["messages"][-1].content
    return {"messages": state["messages"], "next": "ai"}

def ai(state):
    messages = state["messages"]
    
    prompt = ChatPromptTemplate.from_messages([
        ("system", "You are a helpful AI assistant."),
        ("human", "{input}")
    ])
    
    chain = prompt | ChatOpenAI()
    response = chain.invoke({"input": messages[-1].content})
    
    return {"messages": messages + [AIMessage(content=response.content)], "next": "human"}

# Create the graph
workflow = Graph()

workflow.add_node("human", human)
workflow.add_node("ai", ai)

workflow.set_entry_point("human")

workflow.add_edge("human", "ai")
workflow.add_edge("ai", "human")

chain = workflow.compile()

# Streamlit UI
st.title("AI Conversation Agent")

if "messages" not in st.session_state:
    st.session_state.messages = []

for message in st.session_state.messages:
    with st.chat_message(message["role"]):
        st.markdown(message["content"])

if prompt := st.chat_input("What is your message?"):
    st.session_state.messages.append({"role": "user", "content": prompt})
    with st.chat_message("user"):
        st.markdown(prompt)

    with st.chat_message("assistant"):
        message_placeholder = st.empty()
        full_response = ""
        
        for s in chain.stream({
            "messages": [HumanMessage(content=prompt)],
            "next": "human"
        }):
            if s["next"] == "human":
                full_response = s["messages"][-1].content
                message_placeholder.markdown(full_response + "▌")
        
        message_placeholder.markdown(full_response)
    st.session_state.messages.append({"role": "assistant", "content": full_response})