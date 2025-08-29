-- =============================================================
-- Author:
-- Create date: 28/08/2025 
-- Description: Create a new BUTTON if it does not already exist
-- =============================================================
USE JARVISVALLEDULCE
GO

ALTER PROCEDURE [dbo].[SP_CREATEBUTTON]
    @buttonMask CHAR(6),
    @buttonName VARCHAR(50),
    @maskCategory CHAR(8),
    @position INT,
    @fromDate DATE,
    @untilDate DATE,
    @specificDate DATE,
    @enabledDays INT,
    @Products NVARCHAR(MAX) = NULL
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM [dbo].[buttons] WHERE [buttonMask] = @buttonMask)
    BEGIN
        SET NOCOUNT ON;
        BEGIN TRY
            BEGIN TRANSACTION

            -- Sino existe el botón, se crea
            INSERT INTO [dbo].[buttons]
            ([buttonMask], [buttonName], [maskCategory],
            [position], [enabledDays], [fromDate], [untilDate], [specificDate])

            VALUES(@buttonMask, @buttonName, @maskCategory, @position, @enabledDays, @fromDate, @untilDate, @specificDate)
            
            -- Si se proporcionan productos, se insertan en buttonProducts
            IF @Products IS NOT NULL
            BEGIN
            -- Tabla temparal para manejar los productos del botón
                DECLARE @tempProducts TABLE(
                    id INT IDENTITY(1,1) PRIMARY KEY,
                    maskProduct CHAR(8),
                    quantity INT,
                    screen INT
                )

                -- Insertar los productos desde el JSON a la tabla temporal
                INSERT INTO @tempProducts (maskProduct, quantity, screen)
                SELECT maskProduct, quantity, screen
                FROM OPENJSON(@Products, '$.Products')
                WITH (
                    maskProduct CHAR(8) '$.maskProduct',
                    quantity INT '$.quantity',
                    screen INT '$.screen'
                )

                -- Insertar los productos desde la tabla temporal a buttonProducts
                DECLARE @i INT = 1, @max INT, @maskProduct CHAR(8), @quantity INT, @screen INT
                SELECT @max = COUNT(*) FROM @tempProducts

                -- Recorrer la tabla temporal e insertar en buttonProducts
                WHILE @i <= @max -- Desde 1 hasta el número maximo de productos
                BEGIN
                    SELECT @maskProduct = maskProduct, @quantity = quantity, @screen = screen
                    FROM @tempProducts WHERE id = @i

                    INSERT INTO [dbo].[buttonProducts]
                    ([buttonMask], [maskProduct], [quantity], [screen])
                    VALUES
                    (@buttonMask, @maskProduct, @quantity, @screen)

                    SET @i = @i + 1
                END

            END

            ELSE BEGIN
                PRINT('No products provided for button ' + @buttonMask + '.');
            END

            COMMIT TRANSACTION;
            PRINT('Button ' + @buttonMask + ' created successfully.');
        END TRY

        BEGIN CATCH
            ROLLBACK TRANSACTION;
            
            DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
            RAISERROR(@ErrorMessage, 16, 1);
        END CATCH
    END
END

-- falta indicar a que Canal y subcanal se asigna el botón creado
-- Y a que grupo de modificadores se asignara el boton



