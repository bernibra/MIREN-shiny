WFO.sp <- readRDS("./WFOsp.rds")

options(mysql = list(
  "host" = "location",
  "port" = 3306,
  "user" = "user",
  "password" = "password"
))

databaseName <- "dbmiren"
table <- "MIREN"
