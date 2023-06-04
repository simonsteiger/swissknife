#' @export
file_copy <- function(file, path) {
    list_lines <- readLines(file)
    vector_lines <- paste0(list_lines, collapse = "\n")
    writeLines(vector_lines, path)
}
