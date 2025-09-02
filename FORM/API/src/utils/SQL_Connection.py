from sqlalchemy import create_engine, text, Engine, MetaData, Table
from sqlalchemy.orm import Session


url = "mssql+pyodbc://sa:123456@localhost/JARVISVALLEDULCE?driver=ODBC+Driver+17+for+SQL+Server&trusted_connection=yes"
engine: Engine = create_engine(url, echo=True)

metadata = MetaData()

buttons = Table('buttons', metadata, autoload_with=engine)



with Session(engine) as conn:
    try:
        result = conn.execute(text("SELECT GETDATE()"))
    except Exception as e:
        ...
