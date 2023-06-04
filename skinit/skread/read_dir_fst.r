box::use(
    cli,
    fst,
    magrittr[`%>%`],
    pr = purrr,
    tbl = tibble,
    lub = lubridate,
    str = stringr,
)

#' @export
read_dir_fst <- function(dir) {
    start <- Sys.time()
    filenames <- list.files(dir)
    only_fst <- str$str_detect(filenames, ".+\\.fst$")
    no_suffix_fst <- str$str_remove(filenames[only_fst], ".fst$")

    if (all(!only_fst)) {
        cli$cli_alert_info("No fst files found in {.path {dir}}.")
        return(NULL)
    }

    list_df_fst <-
        no_suffix_fst %>%
        pr$set_names() %>%
        pr$map(~ tbl$as_tibble(fst$read_fst(paste0(dir, .x, ".fst"))))

    dur <- round(lub$as.duration(Sys.time() - start), 2)
    cli$cli_alert_success("Read {length(list_df_fst)} fst files in {dur}.")

    list(data = list_df_fst, names = no_suffix_fst)
}
