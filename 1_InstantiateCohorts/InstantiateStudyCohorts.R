
cohortsToCreate <- CohortGenerator::createEmptyCohortDefinitionSet()

cohortJsonFiles <- list.files(here("1_InstantiateCohorts", "Cohorts"),
                              full.names = TRUE)

# add cohort definition per file
for (i in seq_len(length(cohortJsonFiles))) {
  cohortJsonFileName <- cohortJsonFiles[i]
  cohortName <- tools::file_path_sans_ext(basename(cohortJsonFileName))
  # Here we read in the JSON in order to create the SQL
  # using [CirceR](https://ohdsi.github.io/CirceR/)
  # If you have your JSON and SQL stored differenly, you can
  # modify this to read your JSON/SQL files however you require
  cohortJson <- readChar(cohortJsonFileName, file.info(
    cohortJsonFileName)$size)
  
  cohortExpression <- CirceR::cohortExpressionFromJson(cohortJson)
  
  cohortSql <- CirceR::buildCohortQuery(
    cohortExpression,
    options = CirceR::createGenerateOptions(generateStats = FALSE))
  cohortsToCreate <- rbind(
    cohortsToCreate, 
    data.frame(
      cohortId = i,
      cohortName = cohortName, 
      sql = cohortSql,
      stringsAsFactors = FALSE))
}

# Create the cohort tables to hold the cohort generation results
cohortTableNames <- CohortGenerator::getCohortTableNames(
  cohortTable = cohortTable)

CohortGenerator::createCohortTables(
  connectionDetails = connectionDetails,
  cohortDatabaseSchema = resultSchema,
  cohortTableNames = cohortTableNames)


# Generate the cohorts
cohortsGenerated <- CohortGenerator::generateCohortSet(
  connectionDetails = connectionDetails,
  cdmDatabaseSchema = cdmDatabaseSchema,
  cohortDatabaseSchema = resultSchema,
  cohortTableNames = cohortTableNames,
  cohortDefinitionSet = cohortsToCreate)




