## install packages

install.packages("tidyverse")
library(tidyverse)
install.packages("lubridate")
library(lubridate)
install.packages("janitor")
library(lubridate)
install.packages("janitor")
library(janitor)
install.packages("readxl")
library(readxl)
library(readr)

## prepare data 

t4 <- read_csv("bike data/202004-divvy-tripdata.csv")
View(t4)
library(readr)
t5 <- read_csv("bike data/202005-divvy-tripdata.csv")
View(t5)
library(readr)
t6 <- read_csv("bike data/202006-divvy-tripdata.csv")
View(t6)
library(readr)
t7 <- read_csv("bike data/202007-divvy-tripdata.csv")
View(t7)
library(readr)
t8 <- read_csv("bike data/202008-divvy-tripdata.csv")
View(t8)
library(readr)
t9 <- read_csv("bike data/202009-divvy-tripdata.csv")
View(t9)
library(readr)
t10 <- read_csv("bike data/202010-divvy-tripdata.csv")
View(t10)
library(readr)
t11 <- read_csv("bike data/202011-divvy-tripdata.csv")
View(t11)
library(readr)
t12 <- read_csv("bike data/202012-divvy-tripdata.csv")
View(t12)
library(readr)
t1 <- read_csv("bike data/202101-divvy-tripdata.csv")
View(t1)
library(readr)
t2 <- read_csv("bike data/202102-divvy-tripdata.csv")
View(t2)
library(readr)
t3 <- read_csv("bike data/202103-divvy-tripdata.csv")
View(t3)

## combine data in one table
tripdata <- rbind(t1,t2,t3,t4,t5,t6,t7,t8,t9,t10,t11,t12)
head(tripdata)

##process phase ,clean data

glimpse(tripdata)
str(tripdata)
select(started_at,ended_at,start_station_name,member_casual,rideable_type) %>%
  na.omit(start_station_name)
head(tripdata)
table(tripdata$member_casual)
tripdata$date <- as.Date(tripdata$started_at) #The default format is yyyy-mm-dd
tripdata$month <- format(as.Date(tripdata$date), "%m")
tripdata$day <- format(as.Date(tripdata$date), "%d")
tripdata$year <- format(as.Date(tripdata$date), "%Y")
tripdata$day_of_week <- format(as.Date(tripdata$date), "%A")

tripdata$ride_length <- difftime(tripdata$ended_at,tripdata$started_at)

is.factor(tripdata$ride_length)
tripdata$ride_length <- as.numeric(as.character(tripdata$ride_length))
is.numeric(tripdata$ride_length)

##CONDUCT DESCRIPTIVE ANALYSIS

tripdata_v2 <- tripdata[!(tripdata$start_station_name == "HQ QR" | tripdata$ride_length<0),]
mean(tripdata_v2$ride_length) #straight average (total ride length / rides)
median(tripdata_v2$ride_length) #midpoint number in the ascending array of ride lengths
max(tripdata_v2$ride_length) #longest ride
min(tripdata_v2$ride_length) #shortest ride
summary(tripdata_v2$ride_length)

aggregate(tripdata_v2$ride_length ~ tripdata_v2$member_casual, FUN = mean)
aggregate(tripdata_v2$ride_length ~ tripdata_v2$member_casual, FUN = median)
aggregate(tripdata_v2$ride_length ~ tripdata_v2$member_casual, FUN = max)
aggregate(tripdata_v2$ride_length ~ tripdata_v2$member_casual, FUN = min)
aggregate(tripdata_v2$ride_length ~ tripdata_v2$member_casual + tripdata_v2$day_of_week,
          FUN = mean)

aggregate(tripdata_v2$ride_length ~ tripdata_v2$member_casual + tripdata_v2$day_of_week,
          FUN = mean)

library(dplyr)
library(lubridate)



## share phase , Let's visualize the number of rides by rider type
tripdata_v2 %>%
  mutate(weekday = wday(started_at, label = TRUE)) %>%
  group_by(member_casual, weekday) %>%
  
  summarise(number_of_rides = n()
            ,average_duration = mean(ride_length)) %>%
  arrange(member_casual, weekday) %>%
 
  ggplot(aes(x = weekday, y = number_of_rides, fill = member_casual)) +
  geom_col(position = "dodge")

##Let's create a visualization for average duration
tripdata_v2 %>%
mutate(weekday = wday(started_at, label = TRUE)) %>%
group_by(member_casual, weekday) %>%
summarise(number_of_rides = n()
,average_duration = mean(ride_length)) %>%
arrange(member_casual, weekday) %>%
ggplot(aes(x = weekday, y = average_duration, fill = member_casual)) +
geom_col(position = "dodge")

#  EXPORT SUMMARY FILE FOR FURTHER ANALYSIS

counts <- aggregate(tripdata_v2$ride_length ~ tripdata_v2$member_casual +
                      tripdata_v2$day_of_week, FUN = mean)
write.csv(counts, file = 'avg_ride_length.csv')
                              
