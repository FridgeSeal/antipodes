library(rvest)
library(stringr)
library(RODBC)
# library(lubridate) # added for reference, but don't import directly
# due to namespace conflicts we'd like to avoid

sql_server_pw <- Sys.getenv("DB_PASSWORD")
if (sql_server_pw == "") {
  print("SQL Server password must be provided via env-var DB_PASSWORD")
  q("no")
}
sql_conn_str_interpolated <- stringr::str_interp("Driver={ODBC Driver 18 for SQL Server};Server=localhost;Database=antipodes;UID=SA;PWD=${sql_server_pw};TrustServerCertificate=yes;")
sql_conn <- odbcDriverConnect(connection=sql_conn_str_interpolated)

latest_update_time <- RODBC::sqlQuery(sql_conn, )

extract_element <- function(page_src, css_path) {
  page_src %>% html_element(css_path) %>% html_text2()
}

clean_numericals <- function(raw_text) {
  str_replace_all(raw_text, "(\\$|%|\\r|\\s)+", "")
}

page <- read_html("https://www.invesco.com/us/financial-products/etfs/product-detail?audienceType=Investor&ticker=BKLN")

tables <- page %>% html_elements("#overview-details")

# Last updated

as_of_datetime <- extract_element(page, ".stacked-top > span:nth-child(1)") %>%
  str_replace_all(pattern="(as of |\\r|\\n)", replacement= " ") %>% 
  str_trim(side="both") %>%
  lubridate::parse_date_time("%m/%d/%Y %I:%M %p", tz="EST")

# Intraday Stats

last_trade <- extract_element(page, ".stacked-top > ul:nth-child(3) > li:nth-child(1) > span:nth-child(1)") %>%
  clean_numericals

current_iiv <- extract_element(page, ".stacked-top > ul:nth-child(3) > li:nth-child(2) > span:nth-child(2)") %>%
  clean_numericals

change <- extract_element(page, "span.text-success:nth-child(1)") %>%
  clean_numericals

change_pct <- extract_element(page, ".stacked-top > ul:nth-child(3) > li:nth-child(4) > span:nth-child(2)") %>%
  clean_numericals

nav_market_close <- extract_element(page, "div.stacked:nth-child(2) > ul:nth-child(2) > li:nth-child(1) > span:nth-child(2)") %>%
  clean_numericals

# Yield data

sec_30_day_yield <- extract_element(page, "div.stacked:nth-child(3) > ul:nth-child(3) > li:nth-child(1) > span:nth-child(2)") %>%
  clean_numericals

distribution_rate <- extract_element(page, "div.stacked:nth-child(3) > ul:nth-child(3) > li:nth-child(2) > span:nth-child(2)") %>%
  clean_numericals

distribution_rate_12_month <- extract_element(page, "div.stacked:nth-child(3) > ul:nth-child(3) > li:nth-child(3) > span:nth-child(2)") %>%
  clean_numericals

sec_30_day_unsubsidised_yield <- extract_element(page, "div.stacked:nth-child(3) > ul:nth-child(3) > li:nth-child(4) > div:nth-child(2) > div:nth-child(1)")  %>%
  clean_numericals

# Prior close
closing_price <- extract_element(page, "div.stacked:nth-child(4) > ul:nth-child(3) > li:nth-child(1) > span:nth-child(2)") %>%
  clean_numericals

bid_ask_midpoint <- extract_element(page, "div.stacked:nth-child(4) > ul:nth-child(3) > li:nth-child(2) > span:nth-child(2)") %>%
  clean_numericals

bid_ask_premium_discount <- extract_element(page, "div.stacked:nth-child(4) > ul:nth-child(3) > li:nth-child(3) > span:nth-child(2)")  %>%
  clean_numericals

bid_ask_premium_discount_pct <- extract_element(page, "div.stacked:nth-child(4) > ul:nth-child(3) > li:nth-child(4) > span:nth-child(2)") %>%
  clean_numericals

bid_ask_spread_median <- extract_element(page, "ul.unstyled:nth-child(1) > li:nth-child(1) > span:nth-child(2)")  %>%
  clean_numericals


# Fund characteristics
libor_3_month <- extract_element(page, "ul.unstyled:nth-child(5) > li:nth-child(1) > span:nth-child(2)")  %>%
  clean_numericals

weighted_avg_price <- extract_element(page, "ul.unstyled:nth-child(5) > li:nth-child(2) > span:nth-child(2)")  %>%
  clean_numericals

