## ---- echo = FALSE, message = FALSE-------------------------------------------
library(SqlRender)
knitr::opts_chunk$set(
  cache = FALSE,
  comment = "#>",
  error = FALSE,
  tidy = FALSE)

# Temp folders used to run the example
exportFolder <- tempfile("CohortDiagnosticsTestExport")
inclusionStatisticsFolder <- tempfile("inclusionStats")



## ----eval=FALSE---------------------------------------------------------------
## remotes::install_github('OHDSI/CohortGenerator')
## remotes::install_github('OHDSI/ROhdsiWebApi')


## ----tidy=FALSE,eval=FALSE----------------------------------------------------
## library(CohortDiagnostics)
## 
## connectionDetails <- createConnectionDetails(dbms = "postgresql",
##                                              server = "localhost/ohdsi",
##                                              user = "joe",
##                                              password = "supersecret")


## ----results = FALSE,message = FALSE,warning=FALSE, message = FALSE,eval=FALSE----
## connectionDetails <- Eunomia::getEunomiaConnectionDetails()
## 
## cdmDatabaseSchema <- "main"
## tempEmulationSchema <- NULL
## cohortDatabaseSchema <- "main"
## cohortTable <- "cohort"


## ----results = FALSE,message = FALSE,warning=FALSE,eval=FALSE-----------------
## library(CohortDiagnostics)
## cohortDefinitionSet <- loadCohortsFromPackage(packageName = "CohortDiagnostics",
##                                               cohortToCreateFile = "settings/CohortsToCreateForTesting.csv")


## ----tidy=FALSE,eval=FALSE----------------------------------------------------
## # Set up url
## baseUrl <- "https://atlas.hosting.com/WebAPI"
## # list of cohort ids
## cohortIds <- c(18345,18346)
## 
## cohortDefinitionSet <- ROhdsiWebApi::exportCohortDefinitionSet(baseUrl = baseUrl,
##                                                                cohortIds = cohortIds,
##                                                                generateStats = TRUE)


## ----results = FALSE,message = FALSE,warning=FALSE,eval=FALSE-----------------
## cohortTableNames <- CohortGenerator::getCohortTableNames(cohortTable = cohortTable)
## 
## # Next create the tables on the database
## CohortGenerator::createCohortTables(connectionDetails = connectionDetails,
##                                     cohortTableNames = cohortTableNames,
##                                     cohortDatabaseSchema = "main",
##                                     incremental = FALSE)
## 
## # Generate the cohort set
## CohortGenerator::generateCohortSet(connectionDetails= connectionDetails,
##                                    cdmDatabaseSchema = cdmDatabaseSchema,
##                                    cohortDatabaseSchema = cohortDatabaseSchema,
##                                    cohortTableNames = cohortTableNames,
##                                    cohortDefinitionSet = cohortDefinitionSet,
##                                    incremental = FALSE)


## ----results = FALSE,message = FALSE,warning=FALSE,eval=FALSE-----------------
## exportFolder <- "export"


## ----results = FALSE,message = FALSE,warning=FALSE,eval=FALSE-----------------
## executeDiagnostics(cohortDefinitionSet,
##                    connectionDetails = connectionDetails,
##                    cohortTable = cohortTable,
##                    cohortDatabaseSchema = cohortDatabaseSchema,
##                    cdmDatabaseSchema = cdmDatabaseSchema,
##                    exportFolder = exportFolder,
##                    databaseId = "MyCdm",
##                    minCellCount = 5)


## ----eval=FALSE---------------------------------------------------------------
## CohortGenerator::dropCohortStatsTables(connectionDetails = connectionDetails,
##                                        cohortDatabaseSchema = cohortDatabaseSchema,
##                                        cohortTableNames = cohortTableNames)


## ----tidy=FALSE,eval=FALSE----------------------------------------------------
## preMergeDiagnosticsFiles(exportFolder)

