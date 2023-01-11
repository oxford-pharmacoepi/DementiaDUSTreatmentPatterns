# read the cohorts using CDM connector
outcome_cohorts <- CDMConnector::readCohortSet(here(
  "1_InstantiateCohorts",
  "Cohorts" 
))

testy <- CDMConnector::generateCohortSet(cdm, outcome_cohorts,
                         cohortTableName = cohortTableStem,
                         overwrite = TRUE)

#check you have numbers for your cohorts
testy$demdustreatpats %>% 
  group_by(cohort_definition_id) %>%
  tally()

#collect the results and save as a csv file (update column names to make them the same as those in package example)
testy$demdustreatpats %>% 
  rename(cohortId = cohort_definition_id ,
         personId = subject_id ,
         startDate = cohort_start_date ,
         endDate = cohort_end_date) %>%
  write.table(.,file = here("1_InstantiateCohorts", "Cohorts", "input_cohorts.csv"), sep=",", row.names=FALSE)


# tsdsdf <- testy$demdustreatpats %>% 
#   rename(cohortId = cohort_definition_id ,
#          personId = subject_id ,
#          startDate = cohort_start_date ,
#          endDate = cohort_end_date) %>% collect()


#write.table(tsdsdf,file = here("1_InstantiateCohorts", "Cohorts", "input_cohorts.csv"))

# set up treatment pattern settings

#create data settings (sets where the data is)
dataSettings <- createDataSettings(OMOP_CDM = FALSE,
                                   cohortLocation = here("1_InstantiateCohorts", "Cohorts", "input_cohorts.csv")
                                  )


#create cohort settings
cohortSettings <-
  createCohortSettings( cohortsToCreate_location = here("1_InstantiateCohorts", "Settings", "cohorts_to_create.csv") ,
                        cohortsFolder = here("1_InstantiateCohorts", "Cohorts"))


#create pathway settings
pathwaySettings <- createPathwaySettings(targetCohortId = 1, eventCohortIds = c(2, 3, 4, 5)) # use the defaults and seems to work due to change of names in older version of package

#update the pathway results 

pathwaySettings$all_settings$analysis1[1] <- "Dementia"
pathwaySettings$all_settings$analysis1[8] <- 90 #splitTime
pathwaySettings$all_settings$analysis1[9] <- 90 #eraCollapseSize
pathwaySettings$all_settings$analysis1[10] <- 10 #combinationWindow
pathwaySettings$all_settings$analysis1[11] <- 30 #minPostCombinationDuration
pathwaySettings$all_settings$analysis1[13] <- 5 #maxPathLength
pathwaySettings$all_settings$analysis1[16] <- 100




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
  saveSettings = saveSettings,
  launchShiny = FALSE
)



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
    #baseUrl = "http://api.ohdsi.org:8080/WebAPI",
    baseUrl = "https://ohdsi.ndorms.ox.ac.uk:8443" ,
    loadCohorts = TRUE)

saveSettings <- createSaveSettings(databaseName = db.name ,
                                   rootFolder = here("Results")
)

TreatmentPatterns::executeTreatmentPatterns(dataSettings = dataSettings,
                                            cohortSettings = cohortSettings,
                                            pathwaySettings = pathwaySettings,
                                            saveSettings = saveSettings)



#####################################
# using data from package directly
#create data settings (sets where the data is)
# dataSettings <- createDataSettings(OMOP_CDM = FALSE,
#                                    cohortLocation = file.path(system.file(package = "TreatmentPatterns"), 
#                                                               "examples", "other format", "inst",
#                                                               "cohorts" , "input_cohorts.csv" ) )
#                                      
# 
# #create cohort settings
# cohortSettings <-
#   createCohortSettings( cohortsToCreate_location = file.path(system.file(package = "TreatmentPatterns"), 
#                                                              "examples", "other format", "inst",
#                                                              "settings" , "cohorts_to_create.csv" ) ,
#                         
#                         cohortsFolder =  file.path(system.file(package = "TreatmentPatterns"),
#                                   "examples", "other format", "inst",
#                                   "cohorts")
#   )
# 
# 
# #create pathway settings
# 
# pathwaySettings <-
#   createPathwaySettings(
#     pathwaySettings_location = here("pathway_settings.csv")
#     
#   )
# 
# 
# #save settings
# if (!file.exists(here("Results"))){
#   dir.create(here("Results"), recursive = TRUE)}
# 
# saveSettings <- createSaveSettings(databaseName = db.name ,
#                                    rootFolder = here("Results")
# )
# 
# #run treatment patters
# 
# TreatmentPatterns::executeTreatmentPatterns(
#   dataSettings = dataSettings,
#   cohortSettings = cohortSettings,
#   pathwaySettings = pathwaySettings,
#   saveSettings = saveSettings
# )
# 






