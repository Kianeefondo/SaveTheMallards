#load packages
library(readxl)
library(dplyr)
library(calendR)

#Get the directory
getwd()

#Set the directory
setwd("Code/RCode")

#reading excel file
data <- read_excel("Think Wild Hotline Data - 2022 & 2023.xlsx", sheet = "2022 ALL")

#Filtering excel file for Mallards
HBC2022 <- filter(data, Species == "MALL")
HBC2022 <- filter(HBC2022, S == "HBC")

#getting all dates in the excel file
HBC2022$Date <- as.Date(HBC2022$Date, format = "%Y-%m-%d")
#initializing date count
date_counts <- HBC2022 %>% count(Date)

#Creating all dates in 2023
start2022 <- as.Date("2022-01-01")
end2022 <- as.Date("2022-12-31")
dates2022 <- seq.Date(from = start2022, to = end2022, by = "day")

#Convert all_dates to a dataframe
all_dates_df <- data.frame(date = dates2022)

#right join
final <- all_dates_df %>% 
  left_join(date_counts, by = c("date" = "Date"))

#Convert NA to 0
final[is.na(final)] <- 0

#initializing calendar
calendR(year = 2022,
        special.days = final$n,
        gradient = TRUE,
        low.col = "#FCFFDD",
        special.col = "#00AAAE",
        legend.pos = "right",
        legend.title = "Incidents")

