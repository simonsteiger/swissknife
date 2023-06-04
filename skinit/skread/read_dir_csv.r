box::use(
    cli,
    magrittr[`%>%`],
    pr = purrr,
    tbl = tibble,
    lub = lubridate,
    str = stringr,
    ut = utils,
)

#' @export
read_dir_csv <- function(dir) {
    start <- Sys.time()
    filenames <- list.files(dir)
    only_csv <- str$str_detect(filenames, ".+\\.csv$")

    if (all(!only_csv)) {
        cli$cli_alert_info("No csv files found in {.path {dir}}.")
        return(NULL)
    }

    no_suffix_csv <- str$str_remove(filenames[only_csv], ".csv$")

    list_df_csv <-
        no_suffix_csv %>%
        pr$set_names() %>%
        pr$map(~ tbl$as_tibble(ut$read.csv(paste0(dir, .x, ".csv"))))

    dur <- round(lub$as.duration(Sys.time() - start), 2)
    cli$cli_alert_success("Read {length(list_df_csv)} csv files in {dur}.")

    list(data = list_df_csv, names = no_suffix_csv)
}
