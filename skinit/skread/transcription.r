box::use(
    str = stringr,
    fst,
)

#' @export
transcribe <- function(source, target, from = NULL, to = NULL) {
    # Assert that user passed both or none of `from` and `to`
    if (sum(is.null(from), is.null(to)) == 1) {
        stop("Require file paths, or directory paths and `from`, `to`.")
    }

    # Name regex for readability
    regex_filename <- "[^\\/]*(?=[.][a-zA-Z]+$)" # get filename w/o extension
    regex_extension <- "(?<=[.])[a-zA-Z]+$"

    # Get file name
    file <- str$str_extract(source, regex_filename)

    # Determine file extension if user passed a full path
    if (is.null(from) && is.null(to)) {
        from <- str$str_extract(source, regex_extension)
        to <- str$str_extract(target, regex_extension)
    }

    # Assign reading function
    f_read <- switch(tolower(from),
        "rdata" = load,
        "csv" = read.csv,
        "fst" = fst$read_fst,
        stop(paste0("Can't read from file format ", from))
    )

    # Assign writing function
    f_write <- switch(tolower(to),
        "csv" = write.csv,
        "fst" = fst$write_fst,
        stop(paste0("Can't write to file format ", to))
    )

    # If user passed a directory, transcribe all files with from
    if (is.na(file)) {
        # Assert that target is a folder
        if (!is.na(str$str_extract(target, regex_filename))) {
            stop("`target` must be a path to a directory, not a file.")
        }
        files <- list.files(source, pattern = paste0(from, "$"))
        names <- str$str_remove(files, paste0("\\.", from))
        for (nms in names) {
            f_read(paste0(source, nms, ".", from))
            f_write(eval(parse(text = nms)), paste0(target, nms, ".", to))
        }
        # If user passed a full path, transcribe that file to target
    } else {
        # Check if user wants to override a file, if yes, abort
        if (source == target) {
            stop("Paths match, won't override files.")
        }
        # Check if user wants to transcribe identical formats, if yes, abort
        if (from == to) {
            stop("File extensions match, can't transcribe.")
        }
        f_read(source)
        f_write(eval(parse(text = file)), target)
    }
}
