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
library(OhdsiSharing)
library(TreatmentPatterns)

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

# driver for DatabaseConnector
downloadJdbcDrivers("postgresql", here()) # if you already have this you can omit and change pathToDriver below
connectionDetails <- createConnectionDetails(dbms = "postgresql",
                                             server =server,
                                             user = user,
                                             password = password,
                                             port = port ,
                                             pathToDriver = here())

# sql dialect used with the OHDSI SqlRender package
targetDialect <-"postgresql"
# schema that contains the OMOP CDM with patient-level data
cdm_database_schema<-"public"
# schema that contains the vocabularies
vocabulary_database_schema<-"public"
# schema where a results table will be created 
results_database_schema<-"results"

# stem for tables to be created in your results schema for this analysis
# You can keep the above names or change them
# Note, any existing tables in your results schema with the same name will be overwritten
cohortTableStem<-"demdustreatpats" # needs to be in lower case


###############################################################################
# run using ATLAS and CDM

dataSettings <- createDataSettings(OMOP_CDM = TRUE,
                                   connectionDetails = connectionDetails,
                                   cdmDatabaseSchema = cdm_database_schema,
                                   cohortDatabaseSchema = results_database_schema,
                                   cohortTable = cohortTableStem)


cohortSettings <-
  createCohortSettings(
    targetCohorts = data.frame(cohortId = c(1),
                               atlasId = c(497),
                               cohortName = c('AnyDementia'),
                               conceptSet = ""),
    eventCohorts = data.frame(cohortId = c(2, 3, 4, 5),
                              atlasId = c(498,499,500, 501),
                              cohortName = c('Donepezil', 'Galantamine',
                                             'Memantine', 'Rivastigmine'),
                              conceptSet = c("", "", "", "")),
    baseUrl = "https://ohdsi.ndorms.ox.ac.uk:8443" , 
    loadCohorts = TRUE)

saveSettings <- createSaveSettings(databaseName = db.name ,
                                   rootFolder = here("Results")
)

TreatmentPatterns::executeTreatmentPatterns(dataSettings = dataSettings,
                                            cohortSettings = cohortSettings,
                                            pathwaySettings = pathwaySettings,
                                            saveSettings = saveSettings)





# Review results -----
TreatmentPatterns::launchResultsExplorer(saveSettings = saveSettings)
TreatmentPatterns::launchResultsExplorer(outputFolder = file.path(saveSettings$rootFolder, "output"))
TreatmentPatterns::launchResultsExplorer(zipFolder = saveSettings$rootFolder)