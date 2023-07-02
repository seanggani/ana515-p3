getwd()
library(tidyverse)
library(dplyr)
storms<-read_csv("StormEvents_details-ftp_v1.0_d2014_c20230330.csv")

#2
limit_cols <- c("BEGIN_YEARMONTH", "EPISODE_ID", "STATE","STATE_FIPS","CZ_NAME","CZ_TYPE","CZ_FIPS","EVENT_TYPE")
limited_df <- storms[limit_cols]
head(limited_df)

#3
arr_df <- arrange(limited_df, "STATE")
head(arr_df)

#4
storms <- storms %>% mutate(STATE = str_to_title(STATE), CZ_NAME = str_to_title(CZ_NAME))
print(select(storms, STATE))

#5
only_county <- filter(storms, CZ_TYPE == "C")
head(only_county)
delete_county <- select(only_county, -CZ_TYPE)
head(delete_county)

#6
storms <- storms %>%
  mutate(
    STATE_FIPS = str_pad(STATE_FIPS, width = 3, side = "left", pad = "0"),
    CZ_FIPS = str_pad(CZ_FIPS, width = 3, side = "left", pad = "0")
  )
storms <- storms %>%
  unite("FIPS", STATE_FIPS, CZ_FIPS, sep="")

#7
storms <- storms %>%
 rename_all(tolower)

#8
a<-data("state")
chosen_state <-data.frame(
  state_name = state.name,
  area = state.area,
  region = state.region
)

#9
sorted_states <- data.frame(table(storms$state))
newset1<- rename(sorted_states,c("state"="Var1"))
merged<-merge(x=newset1,y=chosen_state,by.x="state",by.y="state_name")
print(merged)

#10
storm_plot <- ggplot(merged, aes(x=area, y=Freq)) + geom_point(aes(color=region)) + labs(x="Land area (square miles)", y = "# of storm events in 2014")
storm_plot
