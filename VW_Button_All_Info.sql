-- =============================================================
-- Author:
-- Create date: 29/08/2025 
-- Description: Get button Info
-- =============================================================

USE [JARVISVALLEDULCE]

SELECT * FROM buttons
WHERE buttonName LIKE '%30'
SELECT * FROM categories
SELECT * FROM subchannels
SELECT * FROM channels
SELECT * FROM products
SELECT * FROM buttonProducts
SELECT * FROM ButtonXSubChannel


SELECT * FROM modifiers
SELECT * FROM modifierProducts
SELECT * FROM modifierGroups
SELECT * FROM ModifiersXSubChannel
SELECT * FROM groupXMods
select * from groupXButtons


SELECT t0.buttonMask, t0.buttonName, t0.maskCategory, t1.categoryName, t2.maskProduct, t3.productName, t4.maskSubChannel, t4.price ,t5.subchannelName, t6.maskChannel, t6.channelName
FROM buttons t0
INNER JOIN categories t1 
    ON t0.maskCategory = t1.maskCategory
INNER JOIN buttonProducts t2 
    ON t0.buttonMask = t2.buttonMask
INNER JOIN products t3 
    ON t3.maskProduct = t2.maskProduct
INNER JOIN ButtonXSubChannel t4 
    ON t4.buttonMask = t0.buttonMask
INNER JOIN subchannels t5 
    ON t5.maskSubChannel = t4.maskSubChannel
INNER JOIN channels t6 
    ON t6.maskChannel = t5.maskChannel
WHERE t0.buttonMask = 'B00031'
FOR JSON PATH;

GO

CREATE PROCEDURE dbo.GET_BUTTON_INFO(@ButtonMask CHAR(7), @maskChannel CHAR(8))
AS
BEGIN
    IF EXISTS (SELECT 1 FROM buttons WHERE buttonMask = @ButtonMask)
    BEGIN
        SELECT t0.buttonMask, t0.buttonName, t0.maskCategory, t1.categoryName, t2.maskProduct, t3.productName, t4.maskSubChannel, t4.price ,t5.subchannelName, t6.maskChannel, t6.channelName
        FROM buttons t0
        INNER JOIN categories t1 
            ON t0.maskCategory = t1.maskCategory
        INNER JOIN buttonProducts t2 
            ON t0.buttonMask = t2.buttonMask
        INNER JOIN products t3 
            ON t3.maskProduct = t2.maskProduct
        INNER JOIN ButtonXSubChannel t4 
            ON t4.buttonMask = t0.buttonMask
        INNER JOIN subchannels t5 
            ON t5.maskSubChannel = t4.maskSubChannel
        INNER JOIN channels t6 
            ON t6.maskChannel = t5.maskChannel
        WHERE (@ButtonMask  IS NULL OR t0.buttonMask = @ButtonMask) 
            AND (@maskChannel IS NULL OR t6.maskChannel = @maskChannel)
        FOR JSON PATH;
    END
END;

GO

EXEC dbo.GET_BUTTON_INFO
    @ButtonMask = 'B00031',
    @maskChannel = 'CHA00001'