-- =============================================================
-- Author:
-- Create date: 29/08/2025 
-- Description: Update ButtonProducts from Button
-- =============================================================
USE [JARVISVALLEDULCE]

GO
-- -> Asignar Nuevos Productos a un Boton
CREATE PROCEDURE [dbo].[SP_Modify_Button_Info]
    @buttonMask CHAR(6) NOT NULL,
    @data NVARCHAR(MAX) 
AS
BEGIN
    IF EXISTS (SELECT 1 FROM [dbo].[buttons] WHERE [buttonMask] = @buttonMask) 
    BEGIN
        SET NOCOUNT ON;
        BEGIN TRY
            BEGIN TRANSACTION
            
            DECLARE @Button TABLE(
                id INT IDENTITY(1,1) PRIMARY KEY,
                buttonName CHAR(7),
                maskCategory CHAR(8),
                position INT,
                fromDate DATE,
                untilDate DATE,
                specificDate DATE NULL,
                enabledDays TINYINT NULL
            )

            INSERT INTO @Button (buttonName, maskCategory, [position], fromDate, untilDate, specificDate, enabledDays)
            SELECT buttonName, maskCategory, [position], fromDate, untilDate, specificDate, enabledDays
            FROM OPENJSON(@data, "$.Button")
            WITH(
                buttonName CHAR(7) '$.buttonName',
                maskCategory CHAR(8) '$.maskCategory',
                position INT '$.position',
                fromDate DATE '$.fromDate',
                untilDate DATE '$.untilDate',
                specificDate DATE '$.specificDate',
                enabledDays TINYINT '$.enabledDays'
            )
            
            DECLARE @buttonName CHAR(7), @maskCategory CHAR(8), @position INT, @fromDate DATE,
             @untilDate DATE, @specificDate DATE, @enabledDays TINYINT

            SELECT @buttonName = buttonName, @maskCategory = maskCategory, @position = [position], @fromDate = fromDate,
             @untilDate = untilDate, @specificDate = specificDate, @enabledDays = enabledDays
            FROM @Button

            UPDATE [dbo].[buttons]
            SET buttonName = @buttonName, maskCategory = @maskCategory, [position] = @position,
             fromDate = @fromDate, untilDate = @untilDate, specificDate = @specificDate, enabledDays = @enabledDays
            WHERE buttonMask = @buttonMask

            COMMIT TRANSACTION;

            PRINT('BUTTON: ' + @buttonMask + ' MODIFIED SUCCESSFULLY')
        END TRY
        
        BEGIN CATCH
            ROLLBACK TRANSACTION;
            
            DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
            RAISERROR(@ErrorMessage, 16, 1);
        END CATCH
    END
END
