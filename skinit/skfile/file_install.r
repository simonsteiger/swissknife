box::use(
    cli,
    pr = purrr,
    str = stringr,
    rl = rlang,
    ut = utils,
)

#' @export
file_install <- function(file, ...) {
    vector_lines <- unlist(readLines(file))
    r <- "(?<=library\\()\\w+(?=\\))"
    vector_names <- pr$map_chr(vector_lines, ~ str$str_extract(.x, r))
    nonmiss <- vector_names[!is.na(vector_names)]
    pr$walk(nonmiss, ~ ut$install.packages(.x))
}
