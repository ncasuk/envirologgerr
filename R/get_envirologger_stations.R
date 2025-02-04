#' Function to get available Envirologger API monitoring stations for a user. 
#' 
#' @author Stuart K. Grange
#' 
#' @param user An Envirologger API user-name. 
#' 
#' @param key An Envirologger API key for \code{user}. 
#' 
#' @return Tibble. 
#' 
#' @seealso \href{https://api.airmonitors.net/3.0/documentation}{API Documentation},
#' \code{\link{get_envirologger_data}}
#' 
#' @examples 
#' \dontrun{
#' 
#' get_envirologger_stations(user, key)
#' 
#' }
#' 
#' @export
get_envirologger_stations <- function(user, key) {
  
  # Location
  base_url <- base_envirologger_url(user, key)
  
  # Build query
  query <- stringr::str_c(base_url, "stations")
  
  # Get response
  response <- readLines(query, warn = FALSE)
  
  # Check
  response_check(response)
  
  # Parse
  df <- jsonlite::fromJSON(response)
  
  # Clean names
  names(df) <- str_underscore(names(df))
  names(df) <- ifelse(names(df) == "unique_id", "station", names(df))
  
  # Data types
  df$latitude <- as.numeric(df$latitude)
  df$longitude <- as.numeric(df$longitude)
  
  # Arrange
  df <- df %>% 
    arrange(station) %>% 
    as_tibble()
  
  return(df)
  
}
