from sqlalchemy import create_engine

engine = create_engine('sqlite:///:memory:', echo=True)
[DB_TYPE]+[DB_CONNECTOR]://[USERNAME]:[PASSWORD]@[HOST]:[PORT]/[DB_NAME]

engine = create_engine('sqlite:///:memory:', echo=True)
connection = engine.connect()
result = connection.execute([YOUR_QUERY])
for row in result:
    ...
connection.close()
