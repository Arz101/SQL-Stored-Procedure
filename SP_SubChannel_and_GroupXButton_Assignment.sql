USE [JARVISVALLEDULCE]

GO

ALTER PROCEDURE [dbo].[SP_SubChannel_and_GroupXButton_Assignment]
    @buttonMask CHAR(6),
    @Groups NVARCHAR(MAX) = NULL,
    @SubChannels_Groups NVARCHAR(MAX) = NULL
AS 
BEGIN
    IF EXISTS (SELECT 1 FROM [dbo].[buttons] WHERE [buttonMask] = @buttonMask)
    BEGIN
        SET NOCOUNT ON;
        BEGIN TRY
            BEGIN TRANSACTION

            IF @SubChannels_Groups IS NOT NULL
            BEGIN   
                ---> IF PARA INGRESAR UN BOTON A VARIOS SUBCHANNELS 
                DECLARE @SubChannels_Temp TABLE (
                    id INT IDENTITY(1,1) PRIMARY KEY,
                    maskSubChannel CHAR(9),
                    price DECIMAL(5,2),
                    isEnabled BIT
                )

                INSERT INTO @SubChannels_Temp (maskSubChannel, price, isEnabled)
                SELECT maskSubChannel, price, isEnabled
                FROM OPENJSON(@SubChannels_Groups, '$.SubChannels')
                WITH(
                    maskSubChannel CHAR(9) '$.maskSubChannel',
                    price DECIMAL(5,2) '$.price',
                    isEnabled BIT '$.isEnabled'
                )

                DECLARE @_i INT = 1, @_max INT, @_maskSubChannel CHAR(9), @_price DECIMAL(5,2), @_isEnabled BIT
                SELECT @_max = COUNT(*) FROM @SubChannels_Temp

                WHILE @_i <= @_max
                BEGIN
                    SELECT @_maskSubChannel = maskSubChannel, @_price = price, @_isEnabled = isEnabled
                    FROM @SubChannels_Temp
                    WHERE id = @_i

                    INSERT INTO [dbo].[ButtonXSubChannel] ([buttonMask], [maskSubChannel], [price], [isEnabled])
                    VALUES (@buttonMask, @_maskSubChannel, @_price, @_isEnabled)

                    SET @_i = @_i + 1
                END
            END

            -- Si se proporciona un grupo de modificadores, asignar los modificadores al botón
            IF @Groups IS NOT NULL
            BEGIN
                
                DECLARE @tempModifiersGroups TABLE(
                    id INT IDENTITY(1,1) PRIMARY KEY,
                    maskModGroup CHAR(9),
                    mandatory BIT,
                    isEnabled BIT
                )

                -- Insertar los grupos de modificadores desde el JSON a la tabla temporal
                INSERT INTO @tempModifiersGroups (maskModGroup, mandatory, isEnabled)
                SELECT maskModGroup, mandatory, isEnabled
                FROM OPENJSON(@Groups, '$.GroupModifiers')
                WITH (
                    maskModGroup CHAR(9) '$.maskModGroup',
                    mandatory BIT '$.mandatory',
                    isEnabled BIT '$.isEnabled'
                )

                DECLARE @i INT = 1, @max INT, @maskModGroup CHAR(9), @isEnabled BIT, @mandatory BIT
                SELECT @max = COUNT(*) FROM @tempModifiersGroups

                WHILE @i <= @max
                BEGIN
                    SELECT @maskModGroup = maskModGroup, @mandatory = mandatory, @isEnabled = isEnabled
                    FROM @tempModifiersGroups
                    WHERE id = @i

                    INSERT INTO [dbo].[groupXButtons]([buttonMask], [maskModGroup], [mandatory], [isEnabled])
                    VALUES(@buttonMask, @maskModGroup, @mandatory, @isEnabled)

                    SET @i = @i + 1
                END
            END

            COMMIT TRANSACTION;

            PRINT('SUCCESSFULLY')
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

