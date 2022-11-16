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
    -- The construction of this table could go either way, depending on how it's actually used in the business, and any extra domain knowledge.
    -- That is, intraday stats, yield-data, etc could be separate tables, and we could then have the ticker column as a primary key in each,
    -- this kind of denormalisation is fairly standard practice. However, I chose the one-wide-table approach for this tech test for a couple of reasons:
    --   1. Simplicities sake - from this data source we don't have a last updated for every field, so it's best we do the whole batch atomically
    --        and if we decided we did want to split the tables back out, doing so is safer and mechanically easier than fusing them together.
    --        Additionally, all data is sourced at once, from a single source, so it makes sense to organise it together in the database too.
    --   2. Databases like Snowflake, Clickhouse, etc are "mechanically sympathetic" with wide tables, and minimising join-overhead reduces compute costs
    --        which is especially important for usage-based-pricing in snowflake. This is being used in sql-server, so we don't have to pay compute costs,
    --        but minimsing query complexity isn't a bad thing
    --   3. All these fields appear to be "summary statistics" of varying granluarity (some are day level, some are aggregates), given this and their initial
    --        context, it is reasonable to assume that users will want to query for most of these values at once; however, as noted above this is a very
    --        business/domain specific issue, so in "production scenario", we would attempt to establish expected usage patterns first.
    -- An alternative approach is to keep the underlying tables separate, and use a materialized view to form the single table and exposing that as the
    -- primary table for consumers to use. This effectively nets us the "best of both worlds" at the expense of increased complexity of setup. As per above
    -- points, in a "production scenario" I would likely start with a single table, and if performance issues are encountered, progressively migrate towards
    -- the materialized-view architecture.

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