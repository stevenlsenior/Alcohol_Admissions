# load required packages
library(maptools); library(classInt); library(RColorBrewer)

# load admissions data and map file
data <- read.csv("alcohol_related_admissions.csv", stringsAsFactors = FALSE)
map <- readShapePoly("England_lad_2011_gen_clipped")

# convert name and ONS codes to character for easier matching
map$CODE <- as.character(map$CODE)
map$NAME <- as.character(map$NAME)

# create variables for admissions data in map file
map$ALL <- numeric(length(map$CODE))
map$MALE <- numeric(length(map$CODE))
map$FEMALE <- numeric(length(map$CODE))

# loop over LA entries in mapfile, match to data by name (some mismatches by ONS code)
for(i in 1:length(map$CODE)){
	map$ALL[i] <- data$admissions_per_100000[data$ons_code == map$CODE[i]]
	map$FEMALE[i] <- data$admissions_per_100000_females[data$ons_code == map$CODE[i]]
	map$MALE[i] <- data$admissions_per_100000_males[data$ons_code == map$CODE[i]]
}

# set vector of colours for plotting
breaks <- classIntervals(map$ALL, n = 5, style = "quantile")
cols <- rev(brewer.pal(5, "RdYlGn"))
plot(map, col = cols[findInterval(map$ALL, breaks$brks)])
