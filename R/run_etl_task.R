#' @title to fill in
#' @description to fill in
#' @author Mark Druffel, \email{mdruffel@propellerpdx.com}
#'
#' @details to fill in
#'
#' @param dagid to fill in
#' @param tid to fill in
#' @param env_vars to fill in
#' @param extract logical scalar
#' @param transform to fill in
#' @param load to fill in
#' @param libs to fill in
#' @param verbose to fill in
#'
#' @export


run_etl_task <- function(dagid = NULL,
                         tid = NULL,
                         env_vars = NULL,
                         extract = NULL, # this would feed into call, but how does it know file to param?
                         transform = NULL,  # env_vars would feed into here
                         load = NULL,
                         libs = NULL,
                         verbose = FALSE){
  # Call env_vars -----------------------------------------------------------
  #TODO move to seaduck
  tid <- stringr::str_replace_all(tid, '-','/')
  if(is.null(env_vars) == FALSE){
    if(verbose == TRUE){
      message(glue::glue('jetStream::run_call(call = {env_vars}, libs = {libs}, verbose = {verbose})'))
    }
    env_vars <- run_call(call = env_vars,
                         libs = libs,
                         verbose = verbose)
  } else {
    env_vars <- NULL
  }
  env_vars <- globalEntry::append_vars(dagid = dagid, tid = tid, env_vars = env_vars)
  # Call extract ------------------------------------------------------------
  if(is.null(extract) == FALSE){
    if(verbose == TRUE){
      message(glue::glue('jetStream::run_call(call = {extract}, libs = {libs}, verbose = {verbose})'))
    }
    # Can we use run_call for read with jinja templating in the file names? Or will we need to form the funciton for the user?
    extract <- run_call(call = extract,
                        env_vars = env_vars,
                        libs = libs,
                        verbose = verbose)
    env_vars <- globalEntry::append_vars(extract = extract, env_vars = env_vars)
  } else {
    extract <- NULL
  }

  # Call transform ----------------------------------------------------------
  if(is.null(transform) == FALSE){
    if(verbose == TRUE){
      message(glue::glue('jetStream::run_call(call = {tranform}, libs = {libs}, verbose = {verbose})'))
    }
    # Can we use run_call for read with jinja templating in the file names? Or will we need to form the funciton for the user?
    ## NEED TO ADD INPUT DATA AS A PARAMETER AND FEED INTO TRANFORM
    transform <- run_call(call = transform,
                          env_vars = env_vars,
                          libs = libs,
                          verbose = verbose)
    env_vars <- globalEntry::append_vars(extract = extract, env_vars = env_vars)
  } else {
    transform <- NULL
  }
  if(is.null(load) == FALSE){
    if(verbose == TRUE){
      message(glue::glue('jetStream::run_call(call = {load}, libs = {libs}, verbose = {verbose})'))
    }
    # Can we use run_call for read with jinja templating in the file names? Or will we need to form the funciton for the user?
    ## NEED TO ADD INPUT DATA AS A PARAMETER AND FEED INTO TRANFORM
    load_files <- run_call(call = load,
                           env_vars = env_vars,
                           libs = libs,
                           verbose = verbose,
                           tid = tid)
  } else {
    load_files <- NULL
  }
  # Just testing for now..
  return(load_files)
}
