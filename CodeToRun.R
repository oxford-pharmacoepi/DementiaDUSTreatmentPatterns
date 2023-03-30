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
db.name<-"..."

output.folder <- here("Results", db.name)

# database connection details
server     <- "..."
server_dbi <- "..."
user       <- "..."
password   <- "..."
port       <- "..."
host       <- "..."

# connectionDetails
downloadJdbcDrivers("...", here()) # if you already have this you can omit and change pathToDriver below
connectionDetails <- createConnectionDetails(dbms = "...",
                                             server =server,
                                             user = user,
                                             password = password,
                                             port = port ,
                                             pathToDriver = here())

# cdm schema
cdmDatabaseSchema <- "..."

# results schema
resultSchema <- "..."

#name of the cohort table
cohortTable <- "..."

#name of the study analysis
studyname <- "..."

# instantiate cohorts for study
source(here("InstantiateStudyCohorts.R"))

#run study
source(here("RunAnalysis.R"))

# luanch shiny
launchResultsExplorer(saveSettings = saveSettings)

# to save outputs
saveAsFile()

