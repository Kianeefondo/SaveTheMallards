#load packages
library(readxl)
library(dplyr)
library(sf)
library(ggplot2)
library(data.table)
library(lubridate)

library("sp")
library("raster")
library("broom")
library("rvest")
library("stringr")
library("scales")

library(maps)

#Questions to ask before i forget
# What does species/class/order mean?

#Get the directory
getwd()

#Set the directory
setwd("Code/RCode")

#reading excel file
#reading excel file
data <- read_excel("Think Wild Hotline Data - 2022 & 2023.xlsx", sheet = "2023 ALL",
                   col_names = c("Date", "Time", "Location", "AnimalType", "SpeciesOrigin", "Species",
                                 "AdditionalNotes", "Situation", "CareRequired", "Action", "TimeStamp", "Month", "NA"))

#Different Bird Types
# Waterfowl, Songbird, Upland Game Bird, Upland Game sp, Shorebird or Waterbird, Raptor
#Filter only Window Strike
WindowStrikes <- data %>% filter(Situation == "Window Strike")

#Filter the columns to
#
#   AnimalType | Month | Count(in Window Strike)
#
WindowStrikes2023 <- WindowStrikes %>%
  group_by(AnimalType, Month) %>%
  count(AnimalType, Month)

Months <- list("January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December")
AnimalTypes <- list("Waterfowl", "Songbird", "Upland Game Bird", "Upland Game sp", "Shorebird or Waterbird", "Raptor")
#If AnimalType = 0 on Month, then add (AnimalType, Month, 0) to the df
# You will look through each months
# Filter out for each month for the animal types
# 
for(month in Months){
  WindowMonth <- WindowStrikes2023 %>% filter(Month == month)
  arr <- as.array(WindowMonth$AnimalType)
  # Loop around each animal type
  for(animal in AnimalTypes) {
    #If the string is not in the array
    if(!(animal %in% arr)) {
      # Add animal | month | 0 back to WindowStrikes2023
      new <- data.frame(
        AnimalType = animal,
        Month = month,
        n = 0
      )
      WindowStrikes2023 <- rbind(WindowStrikes2023, new)
    }
  }
}

# Convert Months string type to date time type
# This converts to the numerical value
# The graph changes it to its name automatically
Months <- month.name
WindowStrikes2023$Month <- match(WindowStrikes2023$Month, Months)

# Create Stacked Ordered Area Plot
ggplot(WindowStrikes2023, aes(x = Month, y = n, fill = AnimalType)) +
  geom_area() + 
  scale_x_continuous(
    breaks = 1:12,
    labels = month.name[1:12]
  ) +
  labs(title = "Birds affected by Window Strikes in 2023",
       x = "Months",
       y = "Window Strikes") +
  theme(plot.title = element_text(hjust=0.5))
