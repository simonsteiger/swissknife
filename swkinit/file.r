box::use(
    cli,
    pr = purrr,
    str = stringr,
    rl = rlang,
)

#' @export
init_copy_file <- function(file, path) {
    list_lines <- readLines(file)
    vector_lines <- paste0(list_lines, collapse = "\n")
    writeLines(vector_lines, path)
}

#' @export
#' FIX will fail if lines contain non-lib-calls
#' NULLify all list entries which do not start with library
init_install_from_file <- function(file) {
    vector_lines <- unlist(readLines(file))
    r <- "(?<=library\\()\\w+(?=\\))"
    vector_names <- pr$map_chr(vector_lines, ~ str$str_extract(.x, r))
    nonmiss <- vector_names[!is.na(vector_names)]
    pr$walk(nonmiss, ~ install.packages(.x))
}
