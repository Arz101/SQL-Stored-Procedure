from pydantic import BaseModel
from datetime import date
from typing import Union
from .ButtonXProduct import ButtonXProduct


class CreateButton(BaseModel):
    buttonMask: str
    buttonName: str
    maskCategory: str
    position: int
    fromDate: date
    untilDate: date
    specificDate: Union[date, None] = None
    enabledDays: Union[date, None] = None
    products: list[ButtonXProduct]