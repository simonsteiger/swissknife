box::use(
    tt = testthat,
    tbl = tibble,
    lub = lubridate
)

box::use(
    skf = skwrangle / skfilter,
)

# Create sample data
df <- tbl$tibble(
    name = c(
        "Joe",
        "Joanna",
        "Jason"
    ),
    birthday = c(
        lub$ymd("2002-12-04"),
        lub$ymd("1998-04-22"),
        lub$ymd("1966-08-30")
    )
)

tt$test_that("filter_date_within() errors if interval, year, and quarter NULL", {
    tt$expect_error(skf$filter_date_within(df$birthday))
})

tt$test_that("filter_date_within() errors if interval and year or quarter passed", {
    interval <- c(lub$today(), lub$today() + 1)
    tt$expect_error(skf$filter_date_within(df$birthday, interval, 2))
})

tt$test_that("filter_date_within() errors if length(interval) < 2", {
    interval <- c(lub$today())
    tt$expect_error(skf$filter_date_within(df$birthday, interval))
})

tt$test_that("filter_date_within() errors if length(interval) > 2", {
    interval <- c(lub$today(), lub$today() + 1, lub$today() + 2)
    tt$expect_error(skf$filter_date_within(df$birthday, interval))
})

tt$test_that("filter_date_within() errors if interval duration negative", {
    interval <- c(lub$today(), lub$today() - 1)
    tt$expect_error(skf$filter_date_within(df$birthday, interval))
})

tt$test_that("filter_date_within() errors if interval duration zero", {
    interval <- c(lub$today(), lub$today())
    tt$expect_error(skf$filter_date_within(df$birthday, interval))
})

tt$test_that("filter_date_within() errors if interval date(s) invalid", {
    interval <- c("000", "2000-01-91")
    tt$expect_error(skf$filter_date_within(df$birthday, interval))
})
