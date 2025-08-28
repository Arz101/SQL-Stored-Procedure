USE [JARVISVALLEDULCE]

GO

CREATE PROCEDURE [dbo].[SP_SubChannel_and_GroupXButton_Assignment]
    @buttonMask CHAR(6),
    @maskSubChannel CHAR(6),
    @priceSubChanneel DECIMAL(5,2),
    @isEnabled_SubChannel BIT,
    @Groups NVARCHAR(MAX) = NULL
AS 
BEGIN
    IF EXISTS (SELECT 1 FROM [dbo].[buttons] WHERE [buttonMask] = @buttonMask)
    BEGIN
        SET NOCOUNT ON;
        BEGIN TRY
            BEGIN TRANSACTION

            -- Asignar el botón al subcanal indicado
            INSERT INTO ButtonXSubChannel (buttonMask, maskSubChannel, price, isEnabled)
            VALUES (@buttonMask, @maskSubChannel, @priceSubChanneel, @isEnabled_SubChannel)

            -- Si se proporciona un grupo de modificadores, asignar los modificadores al botón
            IF @Groups IS NOT NULL
            BEGIN
                
                DECLARE @tempModifiersGroups TABLE(
                    id INT IDENTITY(1,1) PRIMARY KEY,
                    maskModGroup CHAR(9),
                    price DECIMAL(5,2),
                    mandatory BIT,
                    isEnabled BIT
                )

                -- Insertar los grupos de modificadores desde el JSON a la tabla temporal
                INSERT INTO @tempModifiersGroups (maskModGroup, price, isEnabled)
                SELECT maskModGroup, price, isEnabled
                FROM OPENJSON(@Groups, '$.GroupModifiers')
                WITH (
                    maskModGroup CHAR(9) '$.maskModGroup',
                    price DECIMAL(5,2) '$.price',
                    mandatory BIT '$.mandatory',
                    isEnabled BIT '$.isEnabled'
                )

                DECLARE @i INT = 1, @max INT, @maskModGroup CHAR(9), @price DECIMAL(5,2), @isEnabled BIT, @mandatory BIT
                SELECT @max = COUNT(*) FROM @tempModifiersGroups

                WHILE @i <= @max
                BEGIN
                    SELECT @maskModGroup = maskModGroup, @price = price, @mandatory = mandatory, @isEnabled = isEnabled
                    FROM @tempModifiersGroups
                    WHERE id = @i

                    INSERT INTO [dbo].[groupXButtons]([buttonMask], [maskModGroup], [mandatory], [isEnabled])
                    VALUES(@buttonMask, @maskModGroup, @mandatory, @isEnabled)

                    SET @i = @i + 1
                END
            END

            COMMIT TRANSACTION;
        END TRY
        BEGIN CATCH
            ROLLBACK TRANSACTION;
            
            DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
            RAISERROR(@ErrorMessage, 16, 1);
        END CATCH
    END
    ELSE
    BEGIN
        RAISERROR('El botón con mask %s no existe.', 16, 1, @buttonMask)
    END
END

----- Asignar el boton a un grupo de modificadores 

SELECT * FROM groupXButtons