from sqlalchemy import create_engine, text, Engine, MetaData, Table
from sqlalchemy.orm import Session
import pyodbc

print(pyodbc.drivers())


url = "mssql+pyodbc://sa:Cr7Siu1111@localhost:1433/JARVISPOSVALLEDULCEPRUEBA?driver=ODBC+Driver+17+for+SQL+Server"
engine: Engine = create_engine(url, echo=True)

metadata = MetaData()

buttons = Table('buttons', metadata, autoload_with=engine)

with Session(engine) as conn:
    try:
        result = conn.execute(text("SELECT GETDATE()")).all()
        print(result)
    except Exception as e:
        raise e 
