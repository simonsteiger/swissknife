box::use(
    pr = purrr,
    str = stringr
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
    list_lines <- readLines(file)
    r <- "(?<=\\()\\w+(?=\\))"
    list_names <- pr$map(list_lines, ~ str$str_extract(.x, r))
    pr$walk(list_names, ~ install.packages(.x))
}
