#' @title Execute R call from string argument
#' @description to fill in
#' @author Mark Druffel, \email{mdruffel@propellerpdx.com}
#'
#' @details to fill in
#'
#' @param call R call
#' @param env_Vars creds and dynamic params
#' @param libs R libs
#' @param verbose logical scalar
#'
#' @examples
#' run_call(call = "harvestR::get_table(table = 'time_entries', user = HARVEST_USER, key = HARVEST_KEY, query = list(from ='2020-07-01', to = '2020-07-15'), strategy = \'multiprocess\')")
#'
#' @export

run_call <- function(call = NULL,
                     env_vars = NULL,
                     libs = NULL,
                     verbose = TRUE,
                     ...
                     ){
  dots <- rlang::dots_list(...)
  if(is.null(dots$tid) == FALSE){
    tid <- dots$tid
  }
  #Should break format_call into two things, check_call & format_call
  # Run check_call
  if(verbose == TRUE & !is.null(libs)){
    message(glue::glue('Attaching libs: {libs}'))
  }
  suppressMessages(lapply(libs, require, character.only = TRUE))

  ##################################################
  # How to assign input_data dfs to the environment?
  ##################################################

  # Attaches credentials for API calls, AWS writes, etc.
  call <- rlang::parse_expr(call)
  #TODO Need to figure out how to deal with badly formed calls, how to stop?
  env_vars %$%
    rlang::eval_tidy(call) -> result
  return(result)
}

