box::use(
    cli,
    fst,
    magrittr[`%>%`],
    lub = lubridate,
    xl = readxl,
    ut = utils,
    str = stringr,
    pr = purrr,
    tbl = tibble,
    str = stringr,
    rl = rlang,
)

box::use(
    . / read_dir_xlsx[...],
    . / read_dir_csv[...],
    . / read_dir_fst[...],
)

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
