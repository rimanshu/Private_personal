## Pandas tutorials for Machine Learning

#Pandas being one of the most popular package in Python is widely used for data manipulation. 
#It is a very powerful and versatile package which makes data cleaning and wrangling much easier and pleasant.

#Import and read Csv file
import pandas as pd
df =pd.read_csv('D:\\Work\\Python\\py_master\\pandas\\1_intro\\nyc_weather.csv')
df

df.to_csv("D:\\Work\\Python\\py_master\\pandas\\1_intro\\nyc_weather.csv") #write csv

df =pd.read_excel("File_name",'Sheet1')

#pd.read_excel to read excel
#df=pd.DataFrame(Pyhton dictionary) to read data from dictionary
#df=pd.DataFrame(Python tuple, coulmn names[]) to read data from tuple
##### https://pandas.pydata.org/pandas-docs/stable/io.html -- TO read dta from everywhere

#df =pd.read_csv("nyc_weather.csv", skiprows=1) -if we have multiple headers
# header =1 to get the 2nd line for header and Header =None -- for no header
#df =pd.read_csv("nyc_weather.csv", nrows=3) -- get no of rows from df excluding header
#df =pd.read_csv("nyc_weather.csv", na_values=["Not Available","na"]) - replace these values to NAN

#use dictonary instead of list when to replace particular coulumn value

#Data Exploration 

type(df.Temperature) # tyepe datatype

#Data Manupulation using Pandas

df['Temperature'].max()
df['EST'][df['Events']=='Rain'] # date and Time when rain
df['WindSpeedMPH'].mean()
df.describe()
df.std()
# Functions and Method
sorted(df), max(), type()
#Methods - df.capitalize(), replace()
#In Python, everythiing is object. Object have methods associated on type

help(max)
#help(any function) 

#DataFrame in Pandas

import pandas as pd
df =pd.read_csv('D:\\Work\\Python\\py_master\\pandas\\1_intro\\nyc_weather.csv')
df

df.shape #(31 rows, 11 coloumn)

rows, columns = df.shape #Rows and column will give numbers

df.head(2)
df.tail(2)

#Indexing

df.index
df.set_index('EST', inplace=True) #set index
df.reset_index(inplace=True)

df[2:5] # include 2 but Exclude 5
df.sample(n = 10) # Select random no. of rows
df.sample(frac = 0.2) #Select fraction of random rows
df[['Events', 'EST','Temperature']]
df[:] #print everything or use df only

df.columns #Extract Column Names 
df.iloc[:2] #Select first 2 rows 
df.iloc[:,:2] #Select first 2 columns
df.loc[:,["col1","col2"]] #Select columns by name

df.query( ) #Filtering

df[df.Temperature>=32] #All the rwos in df where temp is greater than 32
df[df.Temperature == df['Temperature'].max()] # Find the row where temp is max
df[df.Temperature == df.Temperature.max()] #41 and 42 are same]
df[['EST','Humidity']][df.Temperature == df['Temperature'].max()] # for only two columns

df.columns #will give columns name and type
df.Events #Data of column

#Handle Missing Value 

df.fillna(0,inplace=True) #inplace mean change in the dataset.
df.dropna(inplace=True) #drop rows for na values
df.dropna(how="all") #if all values in rows are na
df.dropna(thresh=1)# If atleast one value in rows are not na then will not drop.

new_df = df.fillna({     # use dictonary to change missing value for diff column.
    'Temparature' :0,
    'WindSpeedMPH' :0,
    'Events' :'no event'
})

new_df1 = df.fillna(method="fill")#forward fill for ffill or bfill to copy next day value
#let assume if temp of yesterday was 32 and toadys is 0 which is incorrect
#beacuse it cannot be dropped suddenly. So we need to take value as previous.


new_df = df.interpolate()
#let assume first day temp is 32 and 2nd day is na and 3rd day is 28 so better guess
#would be something middle of between these two so interpolate uses.

new_df2 = df.interpolate(method ='EST')
#What happen when data is like on 1st temp is 32 and 4th temp is na 
#and 5th temp is 28 so temp for 4th should be nearly 28 beacuse time is near than 1st.
#so we use method to use ESt coulmn fpr better interpolate.

replace_df=df.replace([-9999,-8888],np.NaN) #replace the value from another

replace_df1=df.replace(Dict) #We can use dictionary also like above

replace_df=df.replace({
    -9999:0,
    -8888:0,
}np.NaN)

#Let assume your data is 34F as temp and 48 kmp for windspeed then
df=df.replace('[A-Za-z]','', regex=True) #replace alphabates to blanks

df -=df.replace({
    'Temprature' : '[A-Za-z]',
    'WindSpeedMPH' : '[A-Za-z]'
    },'', regex=True)
    
df= df.replace(['poor','average'],[2,1]) #replace list of values to another

########## Groupby, Concat, Merge #####################

group_df= df.groupby('Events')
group_df #<pandas.core.groupby.DataFrameGroupBy object at 0x0000007F6924F908>

for Events, Events_df in group_df:
    print(Events)
    print(Events_df)
    
group_df.get_group('Rain') #For only one field

group_df.max() # max of evey events 

#### This is Split (Groupby) apply (Aggregation functions) then combine(result df)








