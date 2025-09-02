from sqlalchemy import text, select
from sqlalchemy.orm import Session
from ..utils.SQL_Connection import engine, buttons


class ButtonRepo:
    def __init__(self):
        ...

    def get_buttons_info(self, buttonMask: str, maskChannel: str | None):
        with Session(engine) as conn:
            try:
                result = conn.execute(text(
                    F"""
                        EXEC dbo.GET_BUTTON_INFO
                            @ButtonMask = {buttonMask},
                            @maskChannel = {maskChannel}
                    """
                ))

                return result.scalar_one_or_none()
            except Exception as e:
                raise e

    def metadata_test(self):
        with Session(engine) as conn:
            try:
                result = conn.execute(
                    select(buttons).where(buttons.c.buttonMask == "B00031")
                )
                return result.all()
            except Exception as e:
                raise(e)

repo = ButtonRepo()

data = repo.get_buttons_info('B00031', 'CHA00001')
print(data)

    
