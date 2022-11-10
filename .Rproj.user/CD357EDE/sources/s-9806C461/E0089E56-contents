
# instatiate the cohorts

# set up treatment pattern settings

#create data settings (sets where the data is)
dataSettings <- createDataSettings(OMOP_CDM = FALSE,
                                   cohortLocation = here("1_InstantiateCohorts", "Settings", "input_cohorts.csv")
                                  )


#create cohort settings
cohortSettings <-
  createCohortSettings( cohortsToCreate_location = here("1_InstantiateCohorts", "Settings", "cohorts_to_create.csv") ,
                        cohortsFolder = here("1_InstantiateCohorts", "Settings"))


#create pathway settings

pathwaySettings <-
  createPathwaySettings(
    pathwaySettings_location = here("1_InstantiateCohorts", "Settings", "pathway_settings.csv")
    
  )


#save settings
if (!file.exists(here("Results"))){
  dir.create(here("Results"), recursive = TRUE)}

saveSettings <- createSaveSettings(databaseName = db.name ,
                                   rootFolder = here("Results")
                                   )

#run treatment patters

TreatmentPatterns::executeTreatmentPatterns(
  dataSettings = dataSettings,
  cohortSettings = cohortSettings,
  pathwaySettings = pathwaySettings,
  saveSettings = saveSettings
)

