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
data <- read_excel("Think Wild Hotline Data - 2022 & 2023.xlsx", sheet = "2022 ALL")

#Filtering excel file for Mallards
HBC2022 <- filter(data, Species == "MALL")
HBC2022 <- filter(HBC2022, S == "HBC")

#initializing location count
where_count <- HBC2022 %>% count(Location)

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
# Bend : 44.059133, -121.306408
# Redmond: 44.270108, -121.171228

where_count <- as.data.table(where_count)
where_count[, c("x", "y") := list(
  c(-121.306408, -121.171228), #longitude
  c(44.059133, 44.270108) #latitude
)]

#mapping Oregon
OR <- ggplot(data = deschutes_county, mapping = aes(x=long, y=lat)) +
  coord_quickmap() +
  geom_polygon(color="black", fill="#90EE90")
#Placing geometric points & text indicators
OR + geom_point(data = where_count, aes(x = x, y = y, size = n),     
                color = "blue", shape=19, alpha=.5)+ scale_size_continuous(range = c(2, 4),
                                                                           breaks= c(1,2), name="Number of \nReports") +
  geom_text(data = where_count, aes(x = x, y = y + 0.02, label = Location), size = 3.5)

