box::use(
    sh = shiny,
)

#' @export
row2 <- function(content = list(), class = NULL, colwidths = list()) {
    stopifnot(length(content) == length(colwidths))
    stopifnot(is.numeric(unlist(colwidths)))
    stopifnot(sum(unlist(colwidths)) == 12)

    out <- pr$map(seq_along(content), \(i) {
        sh$div(
            class = paste0("col-", colwidths[[i]]),
            content[[i]]
        )
    })

    sh$div(
        class = class %||% "row m-4",
        out
    )
}