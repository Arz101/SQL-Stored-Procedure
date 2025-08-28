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
    @enabledDays = 0,
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
