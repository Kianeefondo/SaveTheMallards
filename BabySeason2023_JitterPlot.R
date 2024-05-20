#load packages
library(readxl)
library(dplyr)
library(sf)
library(ggplot2)
library(data.table)

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
data <- read_excel("Think Wild Hotline Data - 2022 & 2023.xlsx", sheet = "2023 ALL",
                  col_names = c("Date", "Time", "Location", "AnimalType", "SpeciesOrigin", "Species",
                                "AdditionalNotes", "Situation", "CareRequired", "Action", "TimeStamp", "Month", "NA"))

#Situations that are baby season relevant
# "not flighted", "fledgling", "orphaned", "fell from nest"
Baby2023 <- data %>% 
  filter(Situation == "Not flighted" | Situation == "Fledgling" | Situation == "Orphaned" |
         Situation == "Orphaned, Found Alone, Egg Alone")

#clear variable
rm(Babies2023)

#Count by Species
#Set-up January stats
BabiesMonth <- Baby2023 %>% filter(Month == "January")
BabiesMonth <- BabiesMonth %>% count(AnimalType)
Month <- c("January")
Babies2023 <- cbind(BabiesMonth, Month)

#We need to go through all the months to count each animal types for each month.
months <- list("February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December")
for(month in months) {
  BabiesMonth <- Baby2023 %>% filter(Month == month)
  BabiesMonth <- BabiesMonth %>% count(AnimalType)
  Month <- c(month)
  BabiesMonth <- cbind(BabiesMonth, Month)
  Babies2023 <- bind_rows(Babies2023, BabiesMonth)
}

#remove N/A animal types
Babies2023 <- Babies2023 %>% filter(!is.na(AnimalType))

#convert months to date date type
Months <- month.name
Babies2023$Month <- match(Babies2023$Month, Months)
Babies2023$Month <- as.Date(Babies2023$Month, format='%m')

#Different animal types
#temp <- Babies2023 %>% count(AnimalType)

#Jitter plot
# X-axis: 12 months, Y-axis: Count in Babies2023
ggplot(data = Babies2023, aes(x = Month, y = n, col = AnimalType)) +
  #Plotting for AnimalType
  geom_jitter(aes(x = factor(Month), y = n, col = AnimalType),
              width = 0.2,
              height = 0,
              size = 3) +
  scale_x_discrete(labels = substr(month.name, 1, 3)) +
  labs(title = "How long does baby season last based on Animal Type", x = "Months", y = "Babies") +
  theme(plot.title = element_text(hjust=0.5)) +
  geom_smooth(method="lm", aes(x=as.numeric(Month), y=n), formula = (y ~ x), se=FALSE, color=1)

#
#Jitter plot for care required
#
rm(CBabies2023)
CBaby2023 <- Baby2023 %>% filter(CareRequired == "Yes")
CBabiesMonth <- CBaby2023 %>% filter(Month == "January")
CBabiesMonth <- CBabiesMonth %>% count(AnimalType)
Month <- c("January")
CBabies2023 <- cbind(CBabiesMonth, Month)

months <- list("February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December")
for(month in months) {
  CBabiesMonth <- CBaby2023 %>% filter(Month == month)
  CBabiesMonth <- CBabiesMonth %>% count(AnimalType)
  Month <- c(month)
  CBabiesMonth <- cbind(CBabiesMonth, Month)
  CBabies2023 <- bind_rows(CBabies2023, CBabiesMonth)
}
CBabies2023 <- CBabies2023 %>% filter(!is.na(AnimalType))
Months <- month.name
CBabies2023$Month <- match(CBabies2023$Month, Months)
CBabies2023$Month <- as.Date(CBabies2023$Month, format='%m')

ggplot(data = CBabies2023, aes(x = factor(Month), y = n, col = AnimalType)) +
  #Plotting for AnimalType
  geom_jitter(aes(x = factor(Month), y = n, col = AnimalType),
              width = 0.3,
              height = 0,
              size = 3) +
  scale_x_discrete(labels = substr(month.name, 1, 3)) +
  labs(title = "How long does baby season last based on Animal Type (Care Required)", x = "Months", y = "Babies") +
  theme(plot.title = element_text(hjust=0.5)) +
  geom_smooth(method="lm", aes(x=as.numeric(Month), y=n), formula = (y ~ x), se=FALSE, color=1)
