WFO.sp <- readRDS("./WFOsp.rds")

options(mysql = list(
  "host" = "miren-database.clypfqxwro3s.us-east-2.rds.amazonaws.com",
  "port" = 3306,
  "user" = "admiren",
  "password" = "otJh6OYECcEqVWBX4wSN"
))

databaseName <- "dbmiren"
table <- "MIREN"
