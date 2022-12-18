
# instatiate the cohorts

if (!file.exists(output.folder)){
  dir.create(output.folder, recursive = TRUE)}

if (!file.exists(plots.folder)){
  dir.create(plots.folder, recursive = TRUE)}

if (!file.exists(example.plots.folder)){
  dir.create(example.plots.folder, recursive = TRUE)}

# link to db tables -----
person_db<-tbl(db, sql(paste0("SELECT * FROM ",
                              cdm_database_schema,
                              ".person")))
observation_period_db<-tbl(db, sql(paste0("SELECT * FROM ",
                                          cdm_database_schema,
                                          ".observation_period")))
visit_occurrence_db<-tbl(db, sql(paste0("SELECT * FROM ",
                                        cdm_database_schema,
                                        ".visit_occurrence")))
condition_occurrence_db<-tbl(db, sql(paste0("SELECT * FROM ",
                                            cdm_database_schema,
                                            ".condition_occurrence")))
drug_era_db<-tbl(db, sql(paste0("SELECT * FROM ",
                                cdm_database_schema,
                                ".drug_era")))
concept_db<-tbl(db, sql(paste0("SELECT * FROM ",
                               vocabulary_database_schema,
                               ".concept")))
concept_ancestor_db<-tbl(db, sql(paste0("SELECT * FROM ",
                                        vocabulary_database_schema,
                                        ".concept_ancestor")))

death_db<-tbl(db, sql(paste0("SELECT * FROM ",
                             cdm_database_schema,
                             ".death")))


# instantiate study cohorts ----
info(logger, 'INSTANTIATING STUDY COHORTS')
source(here("1_InstantiateCohorts","InstantiateStudyCohorts.R"))
info(logger, 'GOT STUDY COHORTS')

# set up treatment pattern settings --------------------------

#create data settings (sets where the data is) with start and end dates
dataSettings <- createDataSettings(OMOP_CDM = FALSE,
                                   cohortLocation = here("1_InstantiateCohorts", "Settings", "input_cohorts.csv")
                                  )


#create cohort settings ------------------

# cohorts to create is the csv stating cohort ids and which cohort is the target (dementia) and event (anti dementia drugs)
# cohorts folder is the table contain patient information with which cohort they are in and start and stop dates
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




# getting original package to work

# section B) referring to pre specified setting files in a folder - 

dataSettings <- createDataSettings(OMOP_CDM = FALSE, 
                                   cohortLocation = "C:/Users/dnewby/OneDrive - Nexus365/Desktop/treatmentpatterns_test/input_cohorts.csv")
                                                           



