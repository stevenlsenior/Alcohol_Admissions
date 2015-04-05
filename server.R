# load packages
library(shiny); library(maptools); library(classInt); 
library(RColorBrewer); library(ggplot2)

# load data & maps
d <- read.csv("alcohol_related_admissions.csv", stringsAsFactors = FALSE)
m <- readShapePoly("England_lad_2011_gen_clipped")

# convert name and ONS codes to character for easier matching
m$CODE <- as.character(m$CODE)
m$NAME <- as.character(m$NAME)

# create variables for admissions data in map file
m$ALL <- numeric(length(m$CODE))
m$MALE <- numeric(length(m$CODE))
m$FEMALE <- numeric(length(m$CODE))

# Set colours for plotting using quintiles
cols <- rev(brewer.pal(5, "RdYlGn"))

# loop over LA entries in mapfile, match to data by ONS code
for(i in 1:length(m$CODE)){
	m$ALL[i] <- d$admissions_per_100000[d$ons_code == m$CODE[i]]
	m$FEMALE[i] <- d$admissions_per_100000_females[d$ons_code == m$CODE[i]]
	m$MALE[i] <- d$admissions_per_100000_males[d$ons_code == m$CODE[i]]
}

shinyServer(function(input, output) {
	
	output$myPlot <- renderPlot({
		la <<- input$la
		gender <<- input$gender
		
		## Set variables for plotting, use global assignment to enable ggplot later
		if(gender == "both") {
			la_val <<- d$admissions_per_100000[d$local_authority == la]
			admissions <<- d$admissions_per_100000
		}
		else if(gender == "male") {
			la_val <<- d$admissions_per_100000_males[d$local_authority == la]
			admissions <<- d$admissions_per_100000_males
		}
		else if(gender == "female") {
			la_val <<- d$admissions_per_100000_females[d$local_authority == la]
			admissions <<- d$admissions_per_100000_females
		}
				
		# Set line colour on quintile
		breaks <- classIntervals(admissions, n=5, style="quantile")
		line_col <- cols[findInterval(la_val, breaks$brks)]
		
		# Make plot
		dd <- with(density(admissions), data.frame(x,y))
		g <- ggplot(dd, aes(x = x, y = y))
		p <- g + geom_line(color = "black")  +
			layer(data = dd, mapping = aes(x = ifelse(x < la_val, x, la_val), y = y), 
				geom = "area", 
				geom_params = list(fill = line_col)) +
			scale_y_continuous(limits = c(0,max(dd$y)), name="Density") +
			geom_vline(aes(xintercept = la_val), color = line_col, linetype="dashed") +
			scale_x_continuous(name = "Alcohol-related admissions per 100,000 population") + 
			theme_classic()
		print(p)
		
	})
	
	output$myMap <- renderPlot({
			breaks <- classIntervals(m$ALL, n = 5, style = "quantile")
			par(mar = rep(0, 4))
			plot(m, col = cols[findInterval(m$ALL, breaks$brks)])
	})
	
	output$Text1 <- renderText(input$la)
	output$Text2 <- renderText({
		if(input$gender == "both") {
			d$admissions_per_100000[d$local_authority == input$la]
		}
		else if(input$gender == "male") {
			d$admissions_per_100000_males[d$local_authority == input$la]
		}
		else if(input$gender == "female") {
			d$admissions_per_100000_females[d$local_authority == input$la]
		}
	})
	output$Text3 <- renderText({
		if(input$gender == "both") {
			la_val <- d$admissions_per_100000[d$local_authority == input$la]
			admissions <- d$admissions_per_100000
		}
		else if(input$gender == "male") {
			la_val <- d$admissions_per_100000_males[d$local_authority == input$la]
			admissions <- d$admissions_per_100000_males
		}
		else if(input$gender == "female") {
			la_val <- d$admissions_per_100000_females[d$local_authority == input$la]
			admissions <- d$admissions_per_100000_females
		}
		
		worse <- round(sum(la_val > admissions)*100/length(admissions), digits = 2)
		paste(as.character(worse), "%", sep = "")
	})
})