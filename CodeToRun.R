renv::activate()
renv::restore() # this should prompt you to install the various packages required for the study


# packages -----
# load the below packages 
# you should have them all available, with the required version, after
# having run renv::restore above
library(DatabaseConnector)
library(CirceR)
library(CohortGenerator)
library(here)
library(stringr)
library(tibble)
library(dplyr)
library(CDMConnector)
library(RPostgres)
library(TreatmentPatterns)

# database metadata and connection details -----
# The name/ acronym for the database
db.name<-"..."

output.folder <- here("...", db.name)

# database connection details
server     <- "..."
server_dbi <- "..."
user       <- "..."
password   <- "..."
port       <- "..."
host       <- "..."

# driver for DatabaseConnector
downloadJdbcDrivers("...", here()) # if you already have this you can omit and change pathToDriver below
connectionDetails <- createConnectionDetails(dbms = "...",
                                             server =server,
                                             user = user,
                                             password = password,
                                             port = port ,
                                             pathToDriver = here())

# sql dialect used with the OHDSI SqlRender package
targetDialect <-"..."
# schema that contains the OMOP CDM with patient-level data
cdm_database_schema<-"..."
# schema that contains the vocabularies
vocabulary_database_schema<-"..."
# schema where a results table will be created 
results_database_schema<-"..."

# stem for tables to be created in your results schema for this analysis
# You can keep the above names or change them
# Note, any existing tables in your results schema with the same name will be overwritten
cohortTableStem<-"..." # needs to be in lower case

#########################################
## instantiating using CDM connector
##########################################
# instatiate the cohorts
db <- DBI::dbConnect("...", dbname = server_dbi, port = port, host = host, user = user,
                     password = password)


# # cdm reference -----
cdm <- CDMConnector::cdm_from_con(con = db, # connected using DBI dbConnect
                                  cdm_schema = cdm_database_schema, #schema of the database
                                  cdm_tables = tbl_group("clinical"), # which sets of tables needed
                                  write_schema = results_database_schema) # need this to show where to write results to






# Run analysis ----
source(here("RunAnalysis.R"))

# Review results -----
TreatmentPatterns::launchResultsExplorer(saveSettings = saveSettings)
TreatmentPatterns::launchResultsExplorer(output.folder = file.path(saveSettings$rootFolder, "output"))
TreatmentPatterns::launchResultsExplorer(zipFolder = saveSettings$rootFolder)
