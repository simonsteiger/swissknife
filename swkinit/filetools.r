box::use(
    cli,
    pr = purrr,
    str = stringr,
    rl = rlang,
)

#' @export
file_copy <- function(file, path) {
    list_lines <- readLines(file)
    vector_lines <- paste0(list_lines, collapse = "\n")
    writeLines(vector_lines, path)
}

#' @export
file_install <- function(file, ...) {
    vector_lines <- unlist(readLines(file))
    r <- "(?<=library\\()\\w+(?=\\))"
    vector_names <- pr$map_chr(vector_lines, ~ str$str_extract(.x, r))
    nonmiss <- vector_names[!is.na(vector_names)]
    pr$walk(nonmiss, ~ install.packages(.x, ...))
}
