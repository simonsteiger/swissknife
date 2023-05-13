box::use(
    cli,
    fst,
    magrittr[`%>%`],
    lub = lubridate,
    xl = readxl,
    ut = utils,
    str = stringr,
    dp = dplyr,
    pr = purrr,
    tbl = tibble,
    str = stringr,
    rl = rlang,
)

#' @export
init_read <- function(root, as_list = TRUE, name = "list_df") {
    start <- Sys.time()
    filenames <- list.files(root)

    only_csv <- str$str_detect(filenames, ".+\\.csv$")
    only_fst <- str$str_detect(filenames, ".+\\.fst$")
    only_rdata <- str$str_detect(filenames, ".+(\\.[(RD)|(rd)]ata)$|(\\.rda)$")
    only_xlsx <- str$str_detect(filenames, ".+\\.xlsx$")

    if (any(only_rdata)) {
        cli$cli_bullets(c(
            "i" = "This function only reads csv, fst and xlsx files.",
            "x" = "RData file{?s} {filenames[only_rdata]} won't be read."
        ))
    }

    # FANCY make this all a loop into list_rbind
    no_suffix_csv <- str$str_remove(filenames[only_csv], ".csv$")
    no_suffix_fst <- str$str_remove(filenames[only_fst], ".fst$")
    no_suffix_xlsx <- str$str_remove(filenames[only_xlsx], ".xlsx$")
    no_suffix <- c(no_suffix_csv, no_suffix_fst, no_suffix_xlsx)
    # TODO check if any suffix is duplicated, if so, add a _.<filetype> suffix

    list_df_csv <-
        no_suffix_csv %>%
        pr$set_names() %>%
        pr$map(~ tbl$as_tibble(ut$read.csv(paste0(root, .x, ".csv"))))

    list_df_fst <-
        no_suffix_fst %>%
        pr$set_names() %>%
        pr$map(~ tbl$as_tibble(fst$read_fst(paste0(root, .x, ".fst"))))

    list_df_xlsx <-
        no_suffix_xlsx %>%
        pr$set_names() %>%
        pr$map(~ tbl$as_tibble(xl$read_xlsx(paste0(root, .x, ".xlsx"))))

    list_df <-
        list(list_df_csv, list_df_fst, list_df_xlsx) %>%
        pr$list_flatten()

    if (is.null(unlist(list_df))) {
        return(
            cli$cli_inform(c(
                "x" = "No supported file formats found in {.path {root}}.",
                "i" = "Supported file formats are csv, xlsx, and fst."
            ))
        )
    }

    if (as_list) {
        dur <- round(lub$as.duration(Sys.time() - start), 2)
        cli$cli_alert_success("Attached {length(list_df)} data sets to {.var {name}} in {dur}.")
        assign(name, list_df, envir = rl$caller_env())
    } else {
        for (i in seq_along(list_df)) {
            cli$cli_alert_success("Attached {no_suffix[i]}.")
            assign(no_suffix[i], list_df[[i]], envir = rl$caller_env())
        }
    }
}
