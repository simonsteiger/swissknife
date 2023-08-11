box::use(
    str = stringr,
    fst,
)

#' @export
transcribe <- function(from_path, to_path, from_ext = NULL, to_ext = NULL) {
    # Check if user passed either both or none of from_ext and to_ext
    if (sum(is.null(from_ext), is.null(to_ext)) == 1) {
        stop("Require file paths, or directory paths and `from_ext`, `to_ext`.")
    }

    # Check if user wants to override a file, if yes, abort
    if (from_path == to_path && is.null(from_ext) && is.null(to_ext)) {
        stop("Paths match, won't override files.")
    }

    # Name regex for readability
    regex_filename <- "[^\\/]*(?=[.][a-zA-Z]+$)" # get filename w/o extension
    regex_extension <- "(?<=[.])[a-zA-Z]+$"

    # Get file name
    file <- str$str_extract(from_path, regex_filename)

    # Determine file extension if user passed a full path
    if (is.null(from_ext) && is.null(to_ext)) {
        from_ext <- str$str_extract(from_path, regex_extension)
        to_ext <- str$str_extract(to_path, regex_extension)
    }

    # Check if user wants to transcribe identical formats, if yes, abort
    if (from_ext == to_ext) {
        stop("File extensions match, can't transcribe.")
    }

    # Assign reading function
    f_read <- switch(tolower(from_ext),
        "rdata" = load,
        "csv" = read.csv,
        "fst" = fst$read_fst,
        stop(paste0("Can't read from file format ", from_ext))
    )

    # Assign writing function
    f_write <- switch(tolower(to_ext),
        "csv" = write.csv,
        "fst" = fst$write_fst,
        stop(paste0("Can't write to file format ", to_ext))
    )

    # If user passed a directory, transcribe all files with from_ext
    if (is.na(file)) {
        files <- list.files(from_path, pattern = paste0(from_ext, "$"))
        names <- str$str_remove(files, paste0("\\.", from_ext))
        for (nms in names) {
            f_read(paste0(from_path, nms, ".", from_ext))
            f_write(eval(parse(text = nms)), paste0(to_path, nms, ".", to_ext))
        }
    # If user passed a full path, transcribe that file to to_path
    } else {
        f_read(from_path)
        f_write(eval(parse(text = file)), to_path)
    }
}
