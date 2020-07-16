

TODAY <- function(){
  TODAY <- lubridate::today()
  return(TODAY)
}
YESTERDAY <- function(){
  YESTERDAY <- lubridate::today()-1
  return(YESTERDAY)
}
BEGIN_MONTH <- function(){
  BEGIN_MONTH <- lubridate::floor_date(lubridate::today(), unit = 'months')
  return(BEGIN_MONTH)
}
END_MONTH <- function(){
  END_MONTH <- lubridate::ceiling_date(lubridate::today(), unit = 'months')-1
  return(END_MONTH)
}
BEGIN_YEAR <- function(){
  BEGIN_YEAR <- lubridate::floor_date(lubridate::today(), unit = 'years')
  return(BEGIN_YEAR)
}
END_YEAR <- function(offset = 0){
  END_YEAR <- lubridate::ceiling_date(lubridate::today() + offset*365, unit = 'years')-1
  return(END_YEAR)
}
