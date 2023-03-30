# settings for treatment pathways
dataSettings <- createDataSettings(
  connectionDetails = connectionDetails, # connecting to the database
  cdmDatabaseSchema = cdmDatabaseSchema, # "public"
  resultSchema = resultSchema,           # "results"
  cohortTable = cohortTable)             # "cohortTable"

#where you save settings
saveSettings <- createSaveSettings(
  databaseName = db.name,
  rootFolder = output.folder,
  outputFolder = output.folder)

# Select dementia Cohort
targetCohort <- cohortsGenerated %>% 
  filter(cohortName == "any_dementia") %>%
  select(cohortId, cohortName)

# Select everything but dementia cohorts
eventCohorts <- cohortsGenerated %>% 
  filter(cohortName != "any_dementia") %>%
  select(cohortId, cohortName)

cohortSettings <- createCohortSettings(
  targetCohorts = targetCohort,
  eventCohorts = eventCohorts)

pathwaySettings <- createPathwaySettings(
  cohortSettings = cohortSettings,
  studyName = "studyname")

# to add extra analysis
# pathwaySettings <- addPathwayAnalysis(
#   pathwaySettings = pathwaySettings,
#   targetCohortIds = targetCohort$cohortId,
#   eventCohortIds = eventCohorts$cohortId[-1],
#   studyName = "Test")


preConfigure(
  saveSettings = saveSettings,
  cohortSettings = cohortSettings,
  dataSettings = dataSettings,
  cohortTableNames = cohortTableNames)


constructPathways(
  dataSettings = dataSettings,
  pathwaySettings = pathwaySettings,
  saveSettings = saveSettings)


generateOutput(saveSettings = saveSettings)



