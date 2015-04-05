# load packages
library(markdown); library(shiny)

# load data
d <- read.csv("alcohol_related_admissions.csv", stringsAsFactors = FALSE)

# define UI with tab panels for map, plot and documentation
shinyUI(navbarPage("Alcohol-Related Hospital Admissions",
			 
			 tabPanel("Plot",
			 	   
			 	   sidebarPanel(selectInput("la", "Choose a local authority:", 
			 	   				 choices = sort(d$local_authority)),
			 	   		 
			 	   		 selectInput("gender", "Choose which gender to view data for:", 
			 	   		 		choices = c("both", "female", "male")),
			 	   		 
			 	   		 h4("Explanatory text"),
			 	   		 
			 	   		 p("Select a local authority (a local government area in England) 
			  and whether you want to view data for men, women or both sexes. 
			  The app displays where your chosen local authority is in the 
			  distribution of alcohol-related hospital admissions. The colour 
			  indicates which quintile your chosen local authority falls into. A text summary is displayed below the graph.", 
			 	   		   style = "font-family: 'baskerville'; font-si16pt")
			 	   		 
			 	   		 ),
			 	   
			 	   mainPanel(
			 	   	plotOutput("myPlot"),
			 	   	h4("Alcohol-related hospital admissions per 100,000 people:"),
			 	   	verbatimTextOutput("Text2"),
			 	   	h4("% of local authorities that are better than your area:"),
			 	   	verbatimTextOutput("Text3")
			 	   )
			 ),
			 
			 tabPanel("Map",
			 	   sidebarPanel(
			 	   	h4("Alcohol-related hospital admissions per 100,000 people:"),
			 	   	p("This map shows English local authority areas coloured
			 	   	  by alcohol-related hospital admissions per 100,000 
			 	   	  people.", 
			 	   	  style = "font-family: 'baskerville'; font-si16pt"),
			 	   	p("Colours indicate which quintile the area falls 
			 	   	   into, red indicates the highest (i.e worst), dark green indicates the 
			 	   	   lowest (best).", 
			 	   	  style = "font-family: 'baskerville'; font-si16pt"),
			 	   	p("Note: the map may take a few seconds to load.", 
			 	   	  style = "font-family: 'baskerville'; font-si16pt")
			 	   	),
			 	   mainPanel(
			 	   	plotOutput("myMap")
			 	   )
			 ),
			 
			 tabPanel("Documentation",
			 	   mainPanel(
			 	   	h4("Explanatory text"),
			 	   	
			 	   	p("There is a wealth of UK public health data available on 
			  www.data.gov.uk, but much of it is not very accessible without 
			  downloading and processing. The aim of this app is to take a 
			  small part of this data and visualise it, making it more 
			  accessible.", 
			 	   	  style = "font-family: 'baskerville'; font-si16pt"),
			 	   	
			 	   	p("This app allows you to explore alcohol-related admissions 
			  across local authorities in the UK. The data that this app 
			  uses is available at data.gov.uk. The specific file is available 
			  at the link below:", 
			 	   	  style = "font-family: 'baskerville'; font-si16pt"),
			 	   	
			 	   	a(href = "http://www.hscic.gov.uk/catalogue/PUB15483/alc-eng-2014-tab_csv.csv",
			 	   	  "Link to raw alcohol data at data.gov.uk"),
			 	   	
			 	   	p("This app gives you two ways of looking at this data: a 
			 	   	  chloropleth map, where areas are colour-coded by how 
			 	   	  many alcohol-related hospital admissions per 100,000 
			 	   	  people they have; and a plot that shows where a selected 
			 	   	  local authority is in the distribution of all local 
			 	   	  authorities' alcohol-related hospital admissions.", 
			 	   	  style = "font-family: 'baskerville'; font-si16pt"),	
			 	   	
			 	   	p("People who might be interested in this information are local 
			  citizens who want to lobby for action, local government officials 
			  looking to see how their area is doing, or people deciding where 
			  to live.", 
			 	   	  style = "font-family: 'baskerville'; font-si16pt"),
			 	   	
			 	   	a(href = "https://github.com/stevenlsenior/Data_Products",
			 	   	  "Link to source code on GitHub")
			 	   	
			 	   ))
)
)