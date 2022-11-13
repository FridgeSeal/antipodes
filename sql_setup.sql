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
COMMIT TRANSACTION