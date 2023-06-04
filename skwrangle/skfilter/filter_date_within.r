box::use(
    cli,
    magrittr[`%>%`],
    lub = lubridate,
    rl = rlang,
    dp = dplyr,
    pr = purrr,
)

#' @export
filter_date_within <- function(date, interval = NULL, quarter = NULL, year = NULL) {
    # Abort if all inputs are NULL
    if (all(is.null(interval), is.null(quarter), is.null(year))) {
        cli$cli_abort(c(
            "All inputs to {.var {c(interval, quarter, year)}} are NULL.",
            "i" = "At least one of them must not be NULL."
        ))
    }

    # Abort if both interval and quarter or year are provided
    if (!is.null(interval) && (!is.null(quarter) || !is.null(year))) {
        cli$cli_abort(c(
            "Cannot filter for {.var interval}, {.var year} and / or {.var quarter} at the same time.",
            "i" = "Provide either {.var interval} or {.var quarter} and / or {.var year}."
        ))
    }

    # Create interval quosure
    if (!is.null(interval)) {
        # Abort if interval does not contain two entries
        if (length(interval) != 2) {
            cli$cli_abort(c(
                "{.var interval} must contain two elements.",
                "x" = "It contains {length(interval)} element(?s): {.var {interval}}."
            ))
        }
        # Abort if interval contains invalid dates
        invalid_date <- unlist(
            pr$map(interval, \(i) {
                lub$ymd(i, quiet = TRUE) %>%
                    is.na()
            })
        )

        if (any(invalid_date)) {
            cli$cli_abort(c(
                "{.var interval} contains invalid dates.",
                "x" = "{interval[invalid_date]} {?is/are} not a valid date{?s}."
            ))
        }
        # Abort if interval duration is negative or zero
        if (lub$ymd(interval[1]) - lub$ymd(interval[2]) <= 0) {
            cli$cli_abort(c(
                "{.var interval} duration must not be negative or zero.",
                "x" = "{.var interval} duration is {lub$as.duration(lub$interval(interval[1], interval[2]))}."
            ))
        }

        return(
            rl$quo(
                .data[[date]] >= interval[1] & .data[[date]] <= interval[2]
            )
        )
    }

    # Create quarter quosure
    if (!is.null(quarter)) {
        # Abort if quarter does not fall between 1 and 4
        if (!quarter %>% dp$between(1, 4)) {
            cli$cli_abort(c(
                "{.var quarter} must a number between 1 and 4.",
                "x" = "{.var quarter} equals {quarter}"
            ))
        }
        # If no year is provided, fall back to current year and notify user
        if (is.null(year)) {
            cli$cli_alert(c(
                "No {.var year} provided, using {lub$year(lub$today())}."
            ))
            year <- lub$year(lub$today())
        }

        return(
            rl$quo(
                lub$quarter(.data[[date]]) == quarter &
                    lub$year(.data[[date]]) == year
            )
        )
    }

    # Create year quosure
    if (!is.null(year)) {
        # Abort if year is before 1900 or in the future
        if (!year %>% dp$between(1900, lub$year(lub$today()))) {
            cli$cli_abort(c(
                "{.var year} must be between 1900 and {lub$year(lub$today())}.",
                "x" = "{.var year} equals {year}."
            ))
        }

        return(
            rl$quo(
                lub$year(.data[[date]]) == year
            )
        )
    }
}
