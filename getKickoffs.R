# Evaluates generated log files and returns a summary of kickoff yardage for a 
# given player in a given league, over the given year(s).
#
# The user, league, and year args have default values which should be changed.
#
# Note that runtime and memory usage may be high, especially for multiple years.
#
# Args:
#   player: character player name
#   user: character windows username 
#   league: character league name
#   year: numeric vector of variable length specifying years of interest
# Return:
#   str(list); summary of list which contains
#     count = # of kickoffs
#     mean = mean of kickoff yardage
#     sd = standard deviation of kickoff yardage
#     ge60 = vector of # of kickoffs and % of kickoffs with yardage >= 60
#     ge65 = vector of # of kickoffs and % of kickoffs with yardage >= 65
#     le55 = vector of # of kickoffs and % of kickoffs with yardage <= 55
#     le50 = vector of # of kickoffs and % of kickoffs with yardage <= 50
#
# Example usage:
#   getKickoffs("Harvey Soward", user="aston", league="OSFL2007", year="2037")
#   getKickoffs("Les Henry", user="aston", league="cflfiles", year="2035:2040")


getKickoffs <- function(player, 
                        user="aston", 
                        league="OSFL2007", 
                        year=2015) {
  # load necessary lib
  library(XML)
  
  # construct directory
  dirElements <- c("C:", "Users", user, "appdata", "roaming", 
                  "Solecismic Software", "Front Office Football Seven",
                  "leaguehtml", league)
  
  directory <- paste(dirElements, collapse = "\\")
  
  # build list of files, and filter down to necessary logs
  files <- list.files(directory)
  logs <- files[which((substring(files,1,3) == "log")
                & (substring(files,4,7) %in% year))]
  
  # build a list of lines from each log
  lines <- lapply(logs, 
    function(e) {
      # for each log file, return a list of every line individually
      doc <- htmlParse(paste(directory, e, sep = "\\"))
      
      xpathSApply(doc, "//td", xmlValue)
    })
  
  
  # combine lines from all files into one vector
  lines <- do.call(c, lines)
  
  # use regexp to retrieve only kickoff lines
  koLines <- lines[grep("*? kicked off *?", lines)]
  
  # filter down further to player name
  koLines <- koLines[grep(paste("*?",player,"kicked off *?"), koLines)]
  
  # magic number definitions to pick out kickoff yardage
  spacesPre <- 13
  spacesName <- nchar(player)
  spacesPost <- 12
  
  yardageStart <- spacesPre + spacesName + spacesPost + 1
  
  koYardage <- vapply(koLines, 
    function(e) {
      yards <- substring(e, yardageStart, yardageStart + 1)
      # keep in mind this may not be numeric, for onside kickoffs
      yards
    },
    FUN.VALUE = "character")
  
  koYardage <- suppressWarnings(na.omit(as.numeric(koYardage)))
  
  # calc 
  ge60 = length(koYardage[koYardage >= 60])
  ge65 = length(koYardage[koYardage >= 65])
  le55 = length(koYardage[koYardage <= 55])
  le50 = length(koYardage[koYardage <= 50])
  count = length(koYardage)
  
  # return summary data
  result <- list(
    count = count,
    mean = mean(koYardage),
    sd = sd(koYardage),
    ge60 = c(ge60, ge60/count),
    ge65 = c(ge65, ge65/count),
    le55 = c(le55, le55/count),
    le50 = c(le50, le50/count)
  )
  
  return(str(result))
}
