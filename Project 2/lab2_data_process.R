# Load library
library(dplyr)

# Read the data
person_data <- read.csv("data/raw/psam_p_CA.csv")
household_data <- read.csv("psam_h_CA.csv")

# Inner join the two table
data <- person_data %>%
  inner_join(household_data, by = "SERIALNO")

# Select the required columns and remove rows with null values
# WKHP: Usual hours worked per week past 12 months
# OCCP:	Occupation
# SCHL: Educational attainment
# HHT2: Household / family type
# AGEP: Age
# SEX: Gender
filtered_data <- data %>%
  select(WKHP, OCCP, SCHL,HHT2, AGEP, SEX) %>%
  filter(!is.na(WKHP) & !is.na(OCCP) & !is.na(SCHL) & !is.na(HHT2) & !is.na(AGEP) & !is.na(SEX))

# Rename columns to more human-readable names
renamed_data <- filtered_data %>%
  rename(
    hours_worked_weekly = WKHP,
    education_level = SCHL,
    occupation = OCCP,
    household = HHT2,
    age = AGEP,
    gender = SEX
  )

# Export the cleaned data to a new CSV file
write.csv(renamed_data, "data/raw/cleaned_data.csv", row.names = FALSE)
