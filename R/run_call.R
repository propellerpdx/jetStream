#' @title Execute R from a string call
#' @description to fill in
#' @author Mark Druffel, \email{mdruffel@propellerpdx.com}
#'
#' @details to fill in
#'
#' @param call R call
#' @param libs R libs
#' @param verbose logical scalar
#'
#' @examples
#' run_call(call = "harvestR::get_table(table = 'time_entries', user = HARVEST_USER, key = HARVEST_KEY, query = list(from ='2020-01-01', to = '2020-01-01'))")
#'
#' @references
#'
#' @export

run_call <- function(call = NULL,
                     libs = NULL,
                     verbose = TRUE){
  #Should break format_call into two things, check_call & format_call
  # Run check_call
  if(verbose == TRUE & !is.null(libs)){
    message(glue::glue('Attaching libs: {libs}'))
  }
  suppressMessages(lapply(libs, require, character.only = TRUE))
  # Attaches credentials for API calls, AWS writes, etc.
  globalEntry::attach_vars(ENV_VARS = globalEntry::set_vars())
  call <- rlang::parse_expr(call)
  #TODO Need to figure out how to deal with badly formed calls, how to stop?
  result <- rlang::eval_tidy(call)
}
