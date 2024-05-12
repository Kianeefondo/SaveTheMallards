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

#Get the directory
getwd()

#Set the directory
setwd("Code/RCode")

#reading excel file
data <- read_excel("Think Wild Hotline Data - 2022 & 2023.xlsx", sheet = "2023 ALL")

#Filtering excel file for Mallards
HBC2023 <- filter(data, Species == "MALL")
HBC2023 <- filter(HBC2023, Situation == "Hit by Car (HBC)")

#initializing location count
where_count <- HBC2023 %>% count(Location)

#You would prob need to connect the location counts to the locations on the map


#initialize the Choropleth map
#Getting state polygon
states <- map_data("state")
counties <- map_data("county")
OREGON <- filter(states, region == "oregon") #filtering for coords of oregon
OR_counties <- filter(counties, region == "oregon") #county lines of oregon
deschutes_county <- filter(OR_counties, subregion == "deschutes") # deschutes

# The table should look like
# City  |  Count  |  x-lat  |  y-long
# 
# Bend/Deschutes River Woods/Tumalo: 44.014225, -121.380905
# Redmond/Eagle Crest/Cline Falls: 44.277335, -121.224349
# Redmond/Terrebonne/Eagle Crest/Cline Falls: 44.318125, -121.209930

where_count <- as.data.table(where_count)
where_count[, c("x", "y") := list(
  c(-121.380905, -121.224349, -121.209930), #longitude
  c(44.014225, 44.277335, 44.318125) #latitude
  )]

#mapping Oregon
OR <- ggplot(data = deschutes_county, mapping = aes(x=long, y=lat)) +
  coord_quickmap() +
  geom_polygon(color="black", fill="#90EE90")
#Placing geometric points & text indicators
OR + geom_point(data = where_count, aes(x = x, y = y, size = n),     
  color = "blue", shape=19, alpha=.5)+ scale_size_continuous(range = c(2, 4),
  breaks= c(1,6), name="Number of \nReports") +
  geom_text(data = where_count, aes(x = x, y = y + 0.02, label = Location), size = 3.5)
  