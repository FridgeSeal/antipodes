CREATE DATABASE antipodes;
BEGIN TRANSACTION
    CREATE TABLE antipodes.dbo.prices (
        FSYM_ID NVARCHAR(64) NOT NULL,
        P_DATE DATE NOT NULL,
        CURENCY NVARCHAR(8) NOT NULL,
        P_PRICE DECIMAL(19,4) NOT NULL
     -- we could use the MONEY data type, but research suggests
     -- it is functionally identical, with some minor other downsides
    )
    
    CREATE TABLE antipodes.dbo.dividends (
        FSYM_ID NVARCHAR(64) NOT NULL,
        P_DIVS_EXDATE DATE NOT NULL,
        P_DIVS_PD DECIMAL(19,4) NOT NULL
    )
COMMIT;

SELECT p.FSYM_ID, p.P_DATE, SUM(d.P_DIVS_PD)
FROM dividends AS d
JOIN dbo.prices AS p ON d.FSYM_ID = p.FSYM_ID
WHERE p.P_DATE < d.P_DIVS_EXDATE
GROUP BY p.FSYM_ID, p.P_DATE;