#!/usr/bin/env Rscript

# docopt Program ----------------------------------------------------------

doc <-
  'jetStream ETL bash operator provides a command line interface for Apache Airflow to execute DAG tasks that use an ETL pattern in R.

Usage:
  run_etl_task.R --dagid <dag.id> --tid <task.id> --extract <call> [--transform <call>] --load <call> [--env_vars <call>] [--libs <name>] [--verbose <TRUE | FALSE>]

Options:
  --dagid <dag.id>        Airflow DAG ID available through macros: https://airflow.apache.org/docs/stable/macros-ref.
  --tid <task.id>         Airflow Task ID available through macros: https://airflow.apache.org/docs/stable/macros-ref.
  --extract <call>        R call to extract data, syntax can be provided by format_call().
  --tranform <call>       R call to transform data from extract, syntax can be provided by format_call().
  --load <call>           R call to load output to a specified system, syntax can be provided by format_call().
  --env_vars <call>       R call to provide `call` with necessary vars, syntax can be provided by format_call().
  --libs <name>           R libraries to attach to --call runtime environment.
  --verbose <T|F>         Verbose messaging from R
  -h --help               Show this screen.
  --version               Show version.'

opts <- docopt::docopt(doc, version = 'jetStream verion 0.0.0', quoted_args = T)
print(opts)
# Setup Vars --------------------------------------------------------------

if(is.null(opts$verbose)) {
  opts$verbose <- FALSE
} else if(as.logical(opts$verbose) == FALSE) {
  opts$verbose <- FALSE
} else {
  opts$verbose <- TRUE
}


# Execute User Call -------------------------------------------------------
print("Calling run_etl_task()")
result <- jetStream::run_etl_task(dagid = opts$dagid,
                                  tid = opts$tid,
                                  env_vars = opts$env_vars,
                                  extract = opts$extract,
                                  transform = opts$transform,
                                  load = opts$load,
                                  libs = opts$libs,
                                  verbose = opts$verbose)
return(result)
