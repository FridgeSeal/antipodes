CREATE DATABASE antipodes;
BEGIN TRANSACTION
    CREATE TABLE antipodes.dbo.etf_data (
        ticker NVARCHAR(64) PRIMARY KEY NOT NULL,
        last_updated  DATE NOT NULL,
        current_iiv DECIMAL(19,4),
        change_absolute DECIMAL(19,4),
        change_percentage DECIMAL(19,4),
        nav_market_close DECIMAL(19,4),
        sec_30_day_yield DECIMAL(19,4),
        distribution_rate DECIMAL(19,4),
        distribution_rate_12_month DECIMAL(19,4),
        sec_30_day_unsubsidised_yield DECIMAL(19,4),
        closing_price DECIMAL(19,4),
        bid_ask_midpoint DECIMAL(19,4),
        bid_ask_premium_discount DECIMAL(19,4),
        bid_ask_premium_discount_pct DECIMAL(19,4),
        bid_ask_spread_median DECIMAL(19,4),
        libor_3_moth DECIMAL(19,4),
        weighted_avg_price DECIMAL(19,4),
    )
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