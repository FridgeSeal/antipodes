library(rvest)
library(stringr)
library(odbc)
library(DBI)
library(dplyr)
library(dbplyr)
#library(lubridate) # added for reference, but don't import directly
# due to namespace conflicts we'd like to avoid

# constants and parameters
ticker_id <- "BKLN"

extract_element <- function(page_src, css_path) {
  page_src %>% rvest::html_element(css_path) %>% rvest::html_text2()
}

clean_numericals <- function(raw_text) {
  stringr::str_replace_all(raw_text, "(\\$|%|\\r|\\s)+", "")
}


sql_server_pw <- Sys.getenv("DB_PASSWORD")
if (sql_server_pw == "") {
  print("SQL Server password must be provided via env-var DB_PASSWORD")
  q("no")
}

sql_conn <- DBI::dbConnect(odbc::odbc(), Driver = "ODBC Driver 18 for SQL Server", Server="localhost", Database="antipodes", UID="SA", PWD=sql_server_pw, Port = 1433, TrustServerCertificate="yes")


update_table <- function(conn, tablename, ticker_id, data) {
  last_update_time_db <- tbl(sql_conn, tablename) %>% 
    filter(ticker==ticker_id) %>% 
    summarise(dt = max(last_updated)) %>% 
    dplyr::pull("dt") %>%
    lubridate::parse_date_time("%Y-%m-%d")
  if (is.na(last_update_time_db) || (data$last_updated > last_update_time_db)) {
    print("New data detected - updating table")
    df_with_ticker <- dplyr::mutate(data, ticker=c(ticker_id))
    res <- DBI::dbAppendTable(conn, tablename, df_with_ticker)  
  }
}

process_element <- function(page, css_path) {
  element <- extract_element(page, css_path) %>%
    clean_numericals %>% 
    as.numeric() %>%
    c()
}

process_full_date <- function(page, css_path) {
  # date <- 
    extract_element(page, css_path) %>%
    str_replace_all(pattern="(as of |\\r|\\n)", replacement= " ") %>% 
    str_trim(side="both") %>%
    lubridate::parse_date_time("%m/%d/%Y %I:%M %p", tz="EST")
  #lubridate::with_tz(date,tzone="UTC")
}

process_short_date <- function(page, css_path) {
  # date <- 
    extract_element(page, css_path) %>%
    str_replace_all(pattern="(as of |\\r|\\n)", replacement= " ") %>% 
    str_trim(side="both") %>%
    lubridate::parse_date_time("%m/%d/%Y", tz="EST")
  #lubridate::with_tz(date,tzone="UTC")
}

intraday_data <- function(html_page) {
  last_updated <- process_full_date(html_page,".stacked-top > span:nth-child(1)")
  
  last_trade <- process_element(page, ".stacked-top > ul:nth-child(3) > li:nth-child(1) > span:nth-child(1)")
  current_iiv <- process_element(page, ".stacked-top > ul:nth-child(3) > li:nth-child(2) > span:nth-child(2)")
  change_absolute <- process_element(page, "span.text-success:nth-child(1)") 
  change_percentage <- process_element(page, ".stacked-top > ul:nth-child(3) > li:nth-child(4) > span:nth-child(2)")
  nav_market_close <- process_element(page, "div.stacked:nth-child(2) > ul:nth-child(2) > li:nth-child(1) > span:nth-child(2)")
  dplyr::tibble(
    last_updated, 
    last_trade, 
    current_iiv, 
    change_absolute, 
    change_percentage, 
    nav_market_close)
}

yield_data <- function(html_page) {
  last_updated <- process_short_date(html_page,"div.stacked:nth-child(3) > span:nth-child(1)")
  
  sec_30_day_yield <- process_element(page, "div.stacked:nth-child(3) > ul:nth-child(3) > li:nth-child(1) > span:nth-child(2)")
  
  distribution_rate <- process_element(page, "div.stacked:nth-child(3) > ul:nth-child(3) > li:nth-child(2) > span:nth-child(2)")
  
  distribution_rate_12_month <- process_element(page, "div.stacked:nth-child(3) > ul:nth-child(3) > li:nth-child(3) > span:nth-child(2)")
  
  sec_30_day_unsubsidised_yield <- process_element(page, "div.stacked:nth-child(3) > ul:nth-child(3) > li:nth-child(4) > div:nth-child(2) > div:nth-child(1)")
  
  dplyr::tibble(
    last_updated,
    sec_30_day_yield,
    distribution_rate,
    distribution_rate_12_month,
    sec_30_day_unsubsidised_yield
  )
}

close_data <- function(html_page) {
  last_updated <- process_short_date(html_page,"div.stacked:nth-child(4) > span:nth-child(1)")
  closing_price <- process_element(page, "div.stacked:nth-child(4) > ul:nth-child(3) > li:nth-child(1) > span:nth-child(2)")
  
  bid_ask_midpoint <- process_element(page, "div.stacked:nth-child(4) > ul:nth-child(3) > li:nth-child(2) > span:nth-child(2)")
  
  bid_ask_premium_discount <- process_element(page, "div.stacked:nth-child(4) > ul:nth-child(3) > li:nth-child(3) > span:nth-child(2)")
  
  bid_ask_premium_discount_pct <- process_element(page, "div.stacked:nth-child(4) > ul:nth-child(3) > li:nth-child(4) > span:nth-child(2)")
  
  bid_ask_spread_median <- process_element(page, "ul.unstyled:nth-child(1) > li:nth-child(1) > span:nth-child(2)")
  
  dplyr::tibble(
    last_updated,
    closing_price,
    bid_ask_midpoint,
    bid_ask_premium_discount,
    bid_ask_premium_discount_pct,
    bid_ask_spread_median
  )
}

fund_characteristics <- function(html_page) {
  last_updated <- process_short_date(html_page,"div.stacked:nth-child(6) > span:nth-child(1)")
  yield_to_maturity <- process_element(page, "div.stacked:nth-child(6) > ul:nth-child(3) > li:nth-child(1) > span:nth-child(2)")
  weighted_avg_coupon <- process_element(page, "div.stacked:nth-child(6) > ul:nth-child(3) > li:nth-child(2) > span:nth-child(2)")
  days_until_reset <- process_element(page, "div.stacked:nth-child(6) > ul:nth-child(3) > li:nth-child(3) > span:nth-child(2)")
  dplyr::tibble(
    last_updated,
    yield_to_maturity,
    weighted_avg_coupon,
    days_until_reset
  )
}

page <- read_html("https://www.invesco.com/us/financial-products/etfs/product-detail?audienceType=Investor&ticker=BKLN")

intraday_df <- intraday_data(page) %>% update_table(sql_conn, "intraday_stats", "BKLN", .)
yield_df <- yield_data(page) %>% update_table(sql_conn, "yield", "BKLN", .)
close_data_df <- close_data(page) %>% update_table(sql_conn, "prior_close", "BKLN", .)
fund_characteristics_df <- fund_characteristics(page) %>% update_table(sql_conn, "fund_characteristics", "BKLN", .)

print("ETL Process complete")

