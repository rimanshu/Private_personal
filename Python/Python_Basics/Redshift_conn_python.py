import sqlalchemy as sa
from sqlalchemy.orm import sessionmaker


#>>>>>>>> MAKE CHANGES HERE <<<<<<<<<<<<<
DATABASE = "dwtest"
USER = "youruser"
PASSWORD = "yourpassword"
HOST = "dwtest.awsexample.com"
PORT = "5439"
SCHEMA = "public"

S3_FULL_PATH = 's3://yourbucket/category_pipe.txt'
ARN_CREDENTIALS = 'arn:aws:iam::YOURARN:YOURROLE'
REGION = 'us-east-1'

############ CONNECTING AND CREATING SESSIONS ############
connection_string = "redshift+psycopg2://%s:%s@%s:%s/%s" % (USER,PASSWORD,HOST,str(PORT),DATABASE)
engine = sa.create_engine(connection_string)
session = sessionmaker()
session.configure(bind=engine)
s = session()
SetPath = "SET search_path TO %s" % SCHEMA
s.execute(SetPath)
###########################################################


############ RUNNING COPY ############
copy_command = '''
copy category from '%s'
credentials 'aws_iam_role=%s'
delimiter '|' region '%s';
''' % (S3_FULL_PATH, ARN_CREDENTIALS, REGION)
s.execute(copy_command)
s.commit()
######################################



############ GETTING DATA ############
query = "SELECT * FROM category;"
rr = s.execute(query)
all_results =  rr.fetchall()

def pretty(all_results):
    for row in all_results :
        print("row start >>>>>>>>>>>>>>>>>>>>")
        for r in row :
            print(" ---- %s" % r)
        print("row end >>>>>>>>>>>>>>>>>>>>>>")

pretty(all_results)
s.close()
######################################

