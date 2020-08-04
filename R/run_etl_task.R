#' @title to fill in
#' @description to fill in
#' @author Mark Druffel, \email{mdruffel@propellerpdx.com}
#'
#' @details to fill in
#'
#' @param dagid to fill in
#' @param tid to fill in
#' @param keys to fill in
#' @param extract logical scalar
#' @param transform to fill in
#' @param load to fill in
#' @param libs to fill in
#' @param verbose to fill in
#'
#' @export


run_etl_task <- function(dagid = NULL,
                         tid = NULL,
                         keys = NULL,
                         extract = NULL, # this would feed into call, but how does it know file to param?
                         transform = NULL,  # env_vars would feed into here
                         load = NULL,
                         libs = NULL,
                         verbose = FALSE){
  # Call keys -----------------------------------------------------------
  #TODO move to seaduck
  tid <- stringr::str_replace_all(tid, '-','/')
  if(is.null(keys) == FALSE){
    if(verbose == TRUE){
      message(glue::glue('jetStream::run_call(call = {keys}, libs = {libs}, verbose = {verbose})'))
    }
    keys <- run_call(call = keys,
                         libs = libs,
                         verbose = verbose)
  } else {
    keys <- NULL
  }
  keys <- globalEntry::append_keys(dagid = dagid, tid = tid, keys = keys)
  # Call extract ------------------------------------------------------------
  if(is.null(extract) == FALSE){
    if(verbose == TRUE){
      message(glue::glue('jetStream::run_call(call = {extract}, libs = {libs}, verbose = {verbose})'))
    }
    # Can we use run_call for read with jinja templating in the file names? Or will we need to form the funciton for the user?
    extract <- run_call(call = extract,
                        keys = keys,
                        libs = libs,
                        verbose = verbose)
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
                          keys = keys,
                          libs = libs,
                          verbose = verbose,
                          extract = extract)
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
                           keys = keys,
                           libs = libs,
                           verbose = verbose,
                           tid = tid,
                           extract = extract,
                           transform = transform)
  } else {
    load_files <- NULL
  }
  # Just testing for now..
  return(load_files)
}




