BEGIN TRANSACTION

CREATE TABLE antipodes.dbo.intraday_stats
(
    ticker            NVARCHAR(64) NOT NULL,
    last_updated      DATE         NOT NULL,
    last_trade        DECIMAL(19, 4),
    current_iiv       DECIMAL(19, 4),
    change_absolute   DECIMAL(19, 4),
    change_percentage DECIMAL(19, 4),
    nav_market_close  DECIMAL(19, 4),
)

CREATE TABLE antipodes.dbo.yield
(
    ticker                        NVARCHAR(64) NOT NULL,
    last_updated                  DATE         NOT NULL,
    sec_30_day_yield              DECIMAL(19, 4),
    distribution_rate             DECIMAL(19, 4),
    distribution_rate_12_month    DECIMAL(19, 4),
    sec_30_day_unsubsidised_yield DECIMAL(19, 4)
)

CREATE TABLE antipodes.dbo.prior_close
(
    ticker                       NVARCHAR(64) NOT NULL,
    last_updated                 DATE         NOT NULL,
    closing_price                DECIMAL(19, 4),
    bid_ask_midpoint             DECIMAL(19, 4),
    bid_ask_premium_discount     DECIMAL(19, 4),
    bid_ask_premium_discount_pct DECIMAL(19, 4),
    bid_ask_spread_median        DECIMAL(19, 4),
)


CREATE TABLE antipodes.dbo.fund_characteristics
(
    ticker              NVARCHAR(64) NOT NULL,
    last_updated        DATE         NOT NULL,
    yield_to_maturity   DECIMAL(19, 4),
    weighted_avg_coupon DECIMAL(19, 4),
    days_until_reset    DECIMAL(19, 4),
)


COMMIT TRANSACTION