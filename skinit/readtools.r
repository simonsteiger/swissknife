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

#' @export
read_dir <- function(dir, as_list = TRUE, name = "list_df") {
    start <- Sys.time()
    filenames <- list.files(dir)

    only_rdata <- str$str_detect(filenames, ".+(\\.[(RD)|(rd)]ata)$|(\\.rda)$")

    if (any(only_rdata)) {
        cli$cli_bullets(c(
            "i" = "This function only reads csv, fst and xlsx files.",
            "x" = "RData file{?s} {filenames[only_rdata]} won't be read."
        ))
    }

    fst <- read_dir_fst(dir)
    csv <- read_dir_csv(dir)
    xlsx <- read_dir_xlsx(dir)

    no_suffix <- c(fst$name, csv$name, xlsx$name)
    # TODO check if any suffix is duplicated, if so, add a _.<filetype> suffix

    list_df <-
        list(fst$data, csv$data, xlsx$data) %>%
        pr$list_flatten()

    empty_lists <- pr$map(list_df, is.null)

    if (all(unlist(empty_lists))) {
        return(
            cli$cli_inform(c(
                "x" = "No supported file formats found in {.path {dir}}.",
                "i" = "Supported file formats are csv, xlsx, and fst."
            ))
        )
    }

    # remove NULL lists
    list_df <- list_df[!unlist(empty_lists)]

    if (as_list) {
        dur <- round(lub$as.duration(Sys.time() - start), 2)
        cli$cli_alert_success("Attached {length(list_df)} files to {.var {name}} in {dur}.")
        assign(name, list_df, envir = rl$caller_env())
    } else {
        for (i in seq_along(list_df)) {
            cli$cli_alert_success("Attached {no_suffix[i]}.")
            assign(no_suffix[i], list_df[[i]], envir = rl$caller_env())
        }
    }
}
