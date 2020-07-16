#!/usr/bin/env Rscript

# docopt Program ----------------------------------------------------------

doc <-
  'jetStream bash operator provides a command line interface for Apache Airflow to execute DAG tasks in R.

Usage:
  run_task.R --dagid <dag.id> --tid <task.id> [--libs <name>] --call <call> [--verbose <TRUE | FALSE>]

Options:
  -h --help               Show this screen.
  --version               Show version.
  --dagid <dag.id>        Airflow DAG ID available through macros: https://airflow.apache.org/docs/stable/macros-ref.
  --tid <task.id>         Airflow Task ID available through macros: https://airflow.apache.org/docs/stable/macros-ref.
  --libs <name>           R libraries to attach to --call runtime environment.
  --call <call>           R call expressed as if within active R session. Any globalEntry values should be referred to by name excluding list structure (e.g. HARVEST_USER not ENV_VARS$CREDS$HARVEST_USER)
  --verbose <T|F>         Verbose messaging from airflow_task.R'

opts <- docopt::docopt(doc, version = 'jetStream verion 0.0.0', quoted_args = T)


# Setup Vars --------------------------------------------------------------

if(is.null(rlang::maybe_missing(opts$verbose))) {
  opts$verbose <- FALSE
} else if(as.logical(opts$verbose) == 'FALSE') {
  opts$verbose <- FALSE
} else {
  opts$verbose <- TRUE
}
globalEntry::set_vars()

# Execute User Call -------------------------------------------------------

if(opts$verbose == TRUE){
  message(glue::glue('jetStream::run_call(call = {opts$call}, libs = {opts$libs}, verbose = {opts$verbose})'))
}
result <- run_call(call = opts$call,
                   libs = opts$libs,
                   verbose = opts$verbose)

# Write Data --------------------------------------------------------------

#name the object and save
if(ENV_VARS$VARS$USER_ENV == 'DEV'){
  aws.s3::s3saveRDS(result$data,
                    object = object,
                    bucket = ENV_VARS$VARS$LAKE,
                    check_region = T,
                    key = ENV_VARS$CREDS$AWS_ACCESS_KEY_ID,
                    secret = ENV_VARS$CREDS$AWS_SECRET_ACCESS_KEY)
} else{
  aws.s3::s3saveRDS(result$data,
                    object = object,
                    bucket = ENV_VARS$VARS$LAKE,
                    check_region = TRUE)
}

