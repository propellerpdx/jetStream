#' @title to fill in
#' @description to fill in
#' @author Mark Druffel, \email{mdruffel@propellerpdx.com}
#'
#' @details to fill in
#'
#' @param call to fill in
#' @param verbose to fill in
#'
#' @examples
#' format_call(call = "harvestR::get_table(table = 'time_entries', user = HARVEST_USER, key = HARVEST_KEY, query = list(from ='2020-07-01', to = '2020-07-15'))")
#'
#' @export

format_call <- function(call = NULL, verbose = FALSE, ...){
  dots <- list(...)
  if(is.null(call)){
    stop("call is required, please try again. Example call:
         \"harvestR::get_table(table = \\\'time_entries\\\', user = HARVEST_USER, key = HARVEST_KEY)\"")
  } else if(stringr::str_detect(call, stringr::fixed('$'))){
    stop("`$` is a reserved character in bash. This call will not process properley, please reformat to exclude `$`.")
  } else if(stringr::str_detect(call, '\"')){
    stop("call should be wrapped in `\"`and values inside call should be wrapped in `\'`, please reformate to match the expected syntax. Example call:
         \"harvestR::get_table(table = \\\'time_entries\\\', user = HARVEST_USER, key = HARVEST_KEY)\"")
  } else{
    if(verbose == verbose){
      message('call appears to be properly formatted.')
    }
  }
  if(is.null(dots$run_call) == T){
    string_call <- stringr::str_replace_all(call, '\'', '\\\\\'')
    call_message <- glue::glue("Please be sure to include the double quotes around the call and the backslashes for single quotes inside your call when adding to the Airflow dag: ",
                               "\"{string_call}\"")
    stringr::str_view_all(string = call_message,
                          pattern = string_call,
                          match = NA)
  }
}
