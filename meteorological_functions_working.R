## Import data tables. These are downloaded from the NWERN website as exported
## by the CR 1000(x). So far all the outputs are identical except for the most 
## recent Lordsburg Playa, which is slightly different, and won't work with the 
## code as is.

HollomanTable1.dat <- read.csv("~/NWERN/NWERN_Analysis/HollomanTable1.dat.txt", header=FALSE)
rh_met <- read.csv("~/NWERN/Red Hills/November 2020_2/CR1000XSeries_Table1.dat", header=FALSE)
Lordsburg <- read.csv("~/NWERN/NWERN_Analysis/LordsburgTable1.dat.txt", header=FALSE)
Moab <- read.csv("~/NWERN/NWERN_Analysis/MoabTable1.dat.txt", header=FALSE)
bigspring <- read.csv("~/NWERN/NWERN_Analysis/BigSpringTable1.dat.txt", header=FALSE)
centralplains <- read.csv("~/NWERN/NWERN_Analysis/CPERTable1.dat.txt", header=FALSE)

## Calculate Daily Means for all variables ### NEED TO ADJUST CALCULATING PRECIPITATION (AND SENSIT?) ####

hollo.daily = daily_means(df = HollomanTable1.dat)
rh.daily = daily_means(df = rh_met)
#lordsburg.daily = daily_means(df = Lordsburg)
bigspring.daily = daily_means(bigspring)
centrailplains.daily = daily_means(centralplains)

# create a character vector of variable names
met_variables = names(hollo.daily)


##### make sure that "nwern_weather_graph_function" is loaded into the Global Environment

daily_graph(daily.df = hollo.daily, y = "AvgRH_4m_%")

#alternatively
daily_graph(daily.df = hollo.daily, y = met_variables[9])

weather_graph = function(weather.data, sensor) {
  site_daily = daily_means(df = weather.data)
  met_variables = names(site_daily)
  
  daily_graph(daily.df = site_daily, y = sensor)
}
weather_graph(rh_met, "AvgRH_4m_%")
