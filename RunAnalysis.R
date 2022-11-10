
# instatiate the cohorts

# set up treatment pattern settings

#create data settings
dataSettings <- createDataSettings(OMOP_CDM = TRUE,
                                   connectionDetails = connectionDetails,
                                   cdmDatabaseSchema = cdm_database_schema,
                                   cohortDatabaseSchema = results_database_schema,
                                   cohortTable = cohortTableStem)


#create cohort settings


#create characterization settings


#create pathway settings

#save settings

#run treatment patters

TreatmentPatterns::executeTreatmentPatterns(
  dataSettings = dataSettings,
  cohortSettings = cohortSettings,
  characterizationSettings = characterizationSettings,
  pathwaySettings = pathwaySettings,
  saveSettings = saveSettings
)

