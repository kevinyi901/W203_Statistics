## start from raw, clean things up, save to model data

# Load library
library(readr)
library(dplyr)

# Load data
anes2022 <- read_csv("~/lab1/anes_pilot_2022_csv_20221214.csv")

# number of rows
nrow_original <- nrow(anes2022)

# Filter data based on the condition addressed in questionnaire
  # [votehard] [IF turnout22 IN(1,2,3) OR turnout22ns = 1 OR pipevote22a=2]
anes2022 <- anes2022 %>%
  filter(
    pipevote22a == 2 |
      turnout22 %in% c(1,2,3) |
      turnout22ns == 1
  )
print(nrow(anes2022))

# Filter data based on columns "pid1d", "pid1r", create a new column "party" to combine those 2 columns with value 1,2
  # pid1d, pid1r
    # Question pid1d: Generally speaking, do you usually think of yourself as a Democrat, a Republican?
    # Question pid1r: Generally speaking, do you usually think of yourself as a Republican, a Democrat?
    # ‐1  inapplicable, legitimate skip
    #  1  Democrat
    #  2  Republican
    #  3  Independent
    #  4  Something else

anes2022 <- anes2022 %>%
  filter(
    pid1d %in% c(1, 2) | pid1r %in% c(1, 2)
  ) %>% 
  mutate (
    party = case_when (
      pid1d == 1 ~ 1,
      pid1d == 2 ~ 2,
      pid1r == 1 ~ 1,
      pid1r == 2 ~ 2
    )
  )

# Format data for analysis
  # party: 1 for Democrat, 2 for Republican
anes2022_formatted <- anes2022 [c("votehard", "party")]
anes2022_formatted
write_csv(anes2022_formatted, file="~/lab1/anes2022_formatted.csv")
