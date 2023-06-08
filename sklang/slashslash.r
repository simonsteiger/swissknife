#' @export
#' Check if LHS is type(0), and if TRUE return RHS
`%//%` <- function(x, y) {
    if (length(x) == 0 && !is.null(x)) y else x
}