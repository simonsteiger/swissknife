box::use(
    . / filetools,
    . / readtools,
)

#' Copy a text file into a path
#'
#' \code{file_copy()} copies a text file to a specified path.
#' This simplifies importing a module's dependencies into a new project.
#' @param file Text file, such as a .R or .txt file, to be copied.
#' @param path Path to which the copied file will be written.
#' @examples
#' # Not run
#' if (FALSE) {
#' file_copy("~/.local/R/modules/swissknife/dependencies.r", "dependencies.r")
#' }
#' @export
file_copy <- filetools$file_copy

#' Install packages from a dependencies file
#'
#' \code{file_install()} installs all packages called with \code{library()} in a file.
#' It is useful when working on renv projects outside RStudio, i.e., without RStudios "Package \pkg{pkg} is used but not installed"-Button. 
#' @param file File containing \code{library()} calls.
#' @param ... Additional arguments passed to \code{install.packages()}.
#' @examples
#' # Not run
#' if (FALSE) {
#' file_install("dependencies.r")
#' }
#' @export
file_install <- filetools$file_install

#' Read all tabular data files from a directory
#'
#' \code{read_dir()} reads all csv, xlsx and fst files from the specified directory.
#' Successfully loaded data sets can be accessed from a named list or as tibbles.
#' RData files are currently not supported.
#' @param file A string specifying the directory path from which files should be read.
#' @param as_list A boolean specifying if the loaded data sets should be made available in a named list or as individual data frames. The default is \code{TRUE}.
#' @param name A string specifying the name of the named list. Ignored if \code{as_list} is \code{FALSE}. The default is \code{"list_df"}.
#' @examples
#' # Not run
#' if (FALSE) {
#' read_dir("data/")
#' }
#' @export
read_dir <- readtools$read_dir

#' @export
read_dir_csv <- readtools$read_dir_csv

#' @export
read_dir_xlsx <- readtools$read_dir_xlsx

#' @export
read_dir_fst <- readtools$read_dir_fst