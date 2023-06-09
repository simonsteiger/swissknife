#' @export
#' Check if LHS is type(0); if TRUE return RHS, otherwise LHS
`%//%` <- function(x, y) {
    if (length(x) == 0 && !is.null(x)) y else x
}