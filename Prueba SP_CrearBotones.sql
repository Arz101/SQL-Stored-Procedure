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

DELETE FROM buttonProducts
WHERE buttonMask = 'B00343'

SELECT * FROM buttons
where buttonMask = 'B00343'

select * from ButtonXSubChannel
where buttonMask = 'B00343'
