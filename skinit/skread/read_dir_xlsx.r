box::use(
    cli,
    magrittr[`%>%`],
    pr = purrr,
    tbl = tibble,
    lub = lubridate,
    str = stringr,
    xl = readxl,
)

#' @export
read_dir_xlsx <- function(dir) {
    start <- Sys.time()
    filenames <- list.files(dir)
    only_xlsx <- str$str_detect(filenames, ".+\\.xlsx$")
    no_suffix_xlsx <- str$str_remove(filenames[only_xlsx], ".xlsx$")

    if (all(!only_xlsx)) {
        cli$cli_alert_info("No xlsx files found in {.path {dir}}.")
        return(NULL)
    }

    list_df_xlsx <-
        no_suffix_xlsx %>%
        pr$set_names() %>%
        pr$map(~ tbl$as_tibble(xl$read_xlsx(paste0(dir, .x, ".xlsx"))))

    dur <- round(lub$as.duration(Sys.time() - start), 2)
    cli$cli_alert_success("Read {length(list_df_xlsx)} excel files in {dur}.")

    list(data = list_df_xlsx, names = no_suffix_xlsx)
}