from src.repositories import ButtonRepo
from src.schemas import CreateButton
from fastapi.responses import JSONResponse
from fastapi import HTTPException, status

class Service:
    def __init__(self):
        self.repo = ButtonRepo()

    async def createButton(self, CreateButton):
        return JSONResponse(
            status_code=status.HTTP_200_OK,
            content={"message" : "Button Created Successfully!"}
        )

        
    def get(self, buttonMask: str, maskChannel: str):
        try:
            button = self.repo.get_buttons_info(buttonMask, maskChannel)
        
        except Exception as e:
            raise HTTPException(
                status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                detail={"message" : e}
            )
        
        return JSONResponse(
            status_code=status.HTTP_200_OK,
            content={
                "Button_Info" : button
            }
        )
    
