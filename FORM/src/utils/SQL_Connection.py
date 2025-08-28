import pyodbc
from sqlalchemy import Engine, create_engine, text
from sqlalchemy.orm import Session
import traceback


url = "mssql+pyodbc://sa:123456@localhost/JARVISVALLEDULCE?driver=ODBC+Driver+17+for+SQL+Server"

Engine = create_engine(url, echo=True)

with Session(Engine) as conn:
    try:
        result = conn.execute(text("SELECT * FROM buttons")).all()
        
        if result:
            print(result)

    except Exception:
        traceback.print_exception
        