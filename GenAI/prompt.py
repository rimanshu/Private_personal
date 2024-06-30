from langchain import PromptTemplate
from langchain.llms import openai
from langchain.chains import LLM_Chain

demo_template = ''' I want to act as a financial advisor for people. I easy way, explain the basics of {financial concepts}.'''

prompt = PromptTemplate(

    input_variable = ['financial_concept'],
    template = demo_template
)

prompt.format(financial_concept ='income tax')

llm = (temperature=0.7)

chain1 = LLM_Chain(llm=llm, prompt=prompt)

chain1.run('income tax')

chain1.run('gdp')


## Language Translation 

from langchain import PromptTemplate

template = ''' In an easy way translate the following sentence '{sentence}' into {target_language} '''

language_prompt = PromptTemplate(

    input_variable = ['sentance', 'target_language'],
    template=template,
)

language_prompt.format(sentence = "How are you",translate_language='Hindi')

chain2 = LLM_Chain(llm=llm, prompt=language_prompt)

chain2({'sentence':"How are you", 'target_language':'Hindi'})

from langchain import PromptTemplate, FewShotPromptTemplate

# First create the list of few shot template

example = [
    {"Word":"happy","antonym":"sad"},
    {"Word":"tall","antonym":"short"},
]

# Next, we specify the template to format the example we have provided  
# We use the 'PromptTemplate' class for this

example_formatter_template = """ Word : {Word} Antonym : {antonym} """


example_prompt = PromptTemplate(
    input_variable =["word","antonym"],
    template = example_formatter_template,
)

