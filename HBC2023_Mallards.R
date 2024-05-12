#load packages
library(readxl)
library(dplyr)
library(calendR)

#Get the directory
getwd()

#Set the directory
setwd("Code/RCode")

#reading excel file
data <- read_excel("Think Wild Hotline Data - 2022 & 2023.xlsx", sheet = "2023 ALL")

#Filtering excel file for Mallards
HBC2023 <- filter(data, Species == "MALL")
HBC2023 <- filter(HBC2023, Situation == "Hit by Car (HBC)")
  
#getting all dates in the excel file
HBC2023$Date <- as.Date(HBC2023$Date, format = "%Y-%m-%d")
#initializing date count
date_counts <- HBC2023 %>% count(Date)

#Creating all dates in 2023
start2023 <- as.Date("2023-01-01")
end2023 <- as.Date("2023-12-31")
dates2023 <- seq.Date(from = start2023, to = end2023, by = "day")

#Convert all_dates to a dataframe
all_dates_df <- data.frame(date = dates2023)

#right join
final <- all_dates_df %>% 
  left_join(date_counts, by = c("date" = "Date"))

#Convert NA to 0
final[is.na(final)] <- 0

#initializing calendar
calendR(year = 2023,
        special.days = final$n,
        gradient = TRUE,
        low.col = "#FCFFDD",
        special.col = "#00AAAE",
        legend.pos = "right",
        legend.breaks = 1,
        legend.title = "Incidents")

            