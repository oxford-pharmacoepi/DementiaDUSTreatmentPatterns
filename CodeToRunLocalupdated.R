# packages -----
# load the below packages 
remotes::install_github("darwin-eu-dev/TreatmentPatterns@stand-alone", force = TRUE)
library(TreatmentPatterns)
library(CohortGenerator)
library(CirceR)
library(dplyr)
library(tools)
library(here)

# database metadata and connection details -----
# The name/ acronym for the database
db.name<-"CPRD_GOLD"

output.folder <- here("Results", db.name)

# database connection details
server     <- Sys.getenv("DB_SERVER_cdmgold202007") # GOLD
server_dbi <- Sys.getenv("DB_SERVER_cdmgold202007_dbi") #GOLD
user       <- Sys.getenv("DB_USER")
password   <- Sys.getenv("DB_PASSWORD")
port       <- Sys.getenv("DB_PORT") 
host       <- Sys.getenv("DB_HOST") 

# connectionDetails
downloadJdbcDrivers("postgresql", here()) # if you already have this you can omit and change pathToDriver below
connectionDetails <- createConnectionDetails(dbms = "postgresql",
                                             server =server,
                                             user = user,
                                             password = password,
                                             port = port ,
                                             pathToDriver = here())

# cdm schema
cdmDatabaseSchema <- "public"

# results schema
resultSchema <- "results"

#name of the cohort table
cohortTable <- "DN_treatmentPatternsDUSDem"

#name of the study analysis
studyname <- "DementiaDUS"

# instantiate cohorts for study
source(here("InstantiateStudyCohorts.R"))

#run study
source(here("RunAnalysis.R"))

# luanch shiny
launchResultsExplorer(saveSettings = saveSettings)

# to save outputs
saveAsFile()

