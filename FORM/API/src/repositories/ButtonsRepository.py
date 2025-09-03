from sqlalchemy import text, select
from sqlalchemy.orm import Session
from ..utils.SQL_Connection import engine, buttons
from src.schemas import CreateButton
import json

class ButtonRepo:
    def __init__(self):
        ...

    def get_buttons_info(self, buttonMask: str, maskChannel: str | None):
        with Session(engine) as conn:
            try:
                result = conn.execute(text(
                    F"""
                        EXEC dbo.GET_BUTTON_INFO
                            @ButtonMask = '{buttonMask}',
                            @maskChannel = '{maskChannel}'
                    """
                ))

                row = result.fetchone()

                if row and row[0]:
                    return json.loads(row[0])
                return None
            except Exception as e:
                raise e

    
    def getProducts(self):
        ...

    
    def insert_button(self, CreateButton: CreateButton):
        ...