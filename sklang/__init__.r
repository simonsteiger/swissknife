box::use(
  . / quotools,
  . / infixes,
)

#' Convert a quosure to a named vector
#'
#' Tools to work with quosures.
#' @details The vector entry is named like the object name of the quosure.
#' @param x A \code{quo} object.
#' @examples
#' group <- rlang::quo(cyl)
#' quo2string(group)
#' # $group
#' # [1] "cyl"
#' @export
quo2string <- quotools$quo2string

#' Convert a list of quosures to a list of strings
#'
#' Tools to work with quosures.
#' @details Names of list entries are kept.
#' @param x A \code{quos} object.
#' @examples
#' aes <- rlang::quos(x = hp, y = disp, group = cyl)
#' quos2string(aes)
#' # $x
#' # [1] "hp"
#'
#' # $y
#' # [1] "disp"
#'
#' # $group
#' # [1] "cyl"
#' @export
quos2string <- quotools$quos2string

#' Convert a list of strings to a list of quosures
#'
#' Tools to work with quosures.
#' @details Names of list entries are kept.
#' @param x A list or vector of strings.
#' @examples
#' new_aes <- list(x = "hp", y = "disp", group = "cyl")
#' string2quos(new_aes)
#' # <list_of<quosure>>
#'
#' # $x
#' # <quosure>
#' # expr: ^hp
#' # env:  global
#'
#' # $y
#' # <quosure>
#' # expr: ^disp
#' # env:  global
#'
#' # $group
#' # <quosure>
#' # expr: ^cyl
#' # env:  global
#' @export
string2quos <- quotools$string2quos

#' @export
`%//%` <- infixes$`%00%`

#' @export
`%00%` <- infixes$`%00%`

#' @export
`%na?%` <- infixes$`%na?%`

#' @export
`%nan?%` <- infixes$`%nan?%`
