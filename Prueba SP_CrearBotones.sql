USE [JARVISVALLEDULCE]

SELECT 1 FROM [dbo].[articles] WHERE [maskArticle] = 'M00954'

SELECT * FROM [dbo].[articles] WHERE [articleName] LIKE 'GALLETA%'

DELETE [dbo].[articles]
WHERE [maskArticle] = 'M00954'

SELECT * FROM [dbo].[buttons] WHERE [buttonMask] = 'B00343'

SELECT * FROM buttonProducts
WHERE buttonMask = 'B00343'

SELECT * FROM products
WHERE maskProduct in ( 'PR00025', 'PR00109')

SELECT * FROM categories
SELECT * FROM buttons
WHERE maskCategory = 'CAT00007' and isEnabled = 0

SELECT * FROM channels
SELECT * FROM subchannels ORDER BY maskChannel

SELECT * FROM ButtonXSubChannel
where buttonMask = 'B00149'


--- Ejecutar el procedimiento almacenado para crear un nuevo botón
-- Si el botón ya existe, no se crea
EXEC [dbo].[SP_CREATEBUTTON]
    @buttonMask = 'B00343',
    @buttonName = 'COMBO AHORRO',
    @maskCategory = 'CAT00007',
    @position = 1,
    @fromDate = '2025-07-01',
    @untilDate = '2025-12-31',
    @specificDate = NULL,
    @enabledDays = NULL,
    @Products = '{
        "Products": [
            {
                "buttonMask" : "B00343",
                "maskProduct" : "PR00025",
                "quantity" : 1,
                "screen" : 0
            },

            {
                "buttonMask" : "B00343",
                "maskProduct" : "PR00109",
                "quantity" : 1,
                "screen" : 0
            }
        ]
    }'
-- Falta indicar a que Canal y subcanal se asigna el botón creado

--- Asignar subcanal manualmente



SELECT * FROM buttons
WHERE buttonMask = 'B00343'

SELECT * FROM ButtonXSubChannel
where buttonMask = 'B00343'

INSERT INTO ButtonXSubChannel (buttonMask, maskSubChannel, price, isEnabled)
VALUES ('B00343', 'SCHA00001', 4.15, 1)

update buttons
set enabledDays = NULL
where buttonMask = 'B00343'

UPDATE ButtonXSubChannel
SET isEnabled = 0
WHERE buttonMask = 'B00343' and maskSubChannel = 'SCHA00001'


DELETE FROM buttons
WHERE buttonMask = 'B00343'

SELECT * FROM buttonProducts
WHERE buttonMask = 'B00343'

SELECT * FROM ButtonXSubChannel
where buttonMask = 'B00343'

DELETE FROM ButtonXSubChannel
WHERE buttonMask = 'B00343'

select * from subchannels

UPDATE subchannels
set isEnabled = 0
where maskSubChannel = 'SCHA00002'


-- Probar SP para agregar el boton a un subchannel
EXEC [dbo].[SP_SubChannel_and_GroupXButton_Assignment]
    @buttonMask = 'B00343',
    @SubChannels_Groups = '{
        "SubChannels" : [
            {
                "maskSubChannel" : "SCHA00001",
                "price" : 4.25,
                "isEnabled" : 0
            }
        ]
    }'


-- Agregar boton a subcanal con modificador
EXEC [dbo].[SP_SubChannel_and_GroupXButton_Assignment]
    @buttonMask = 'B00343',
    @Groups = '{
        "GroupModifiers" : [
            {
                "maskModGroup" : "GMOD00001",
                "mandatory" : 0,
                "isEnabled" : 0
            }
        ]
    }',

    @SubChannels_Groups = '{
        "SubChannels" : [
            {
                "maskSubChannel" : "SCHA00001",
                "price" : 4.25,
                "isEnabled" : 0
            }
        ]
    }'

EXEC [dbo].[SP_CREATEBUTTON]
    @buttonMask = 'B00343',
    @buttonName = 'COMBO AHORRO',
    @maskCategory = 'CAT00007',
    @position = 1,
    @fromDate = '2025-07-01',
    @untilDate = '2025-12-31',
    @specificDate = NULL,
    @enabledDays = NULL,
    @Products = '{
        "Products": [
            {
                "buttonMask" : "B00343",
                "maskProduct" : "PR00025",
                "quantity" : 1,
                "screen" : 0
            },

            {
                "buttonMask" : "B00343",
                "maskProduct" : "PR00109",
                "quantity" : 1,
                "screen" : 0
            }
        ]
    }'