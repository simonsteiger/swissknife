box::use(
  pr = purrr,
  rl = rlang
)

# These tools are helpful for modifying user inputs to functions,
# typically those captured with dynamic dots.

#' @export
#' Turn a list of quosures into a list of strings and retain names
quos2string <- function(x) {
  pr$map(x, function(q) rl$as_string(rl$quo_get_expr(q)))
}

#' @export
#' Turn a list or vector of strings into a list of quosures and retain names
string2quos <- function(x) {
  if (is.list(x)) {
    x <- unlist(x)
  }
  rl$parse_quos(x, rl$caller_env())
}
