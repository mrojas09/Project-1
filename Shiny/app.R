#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(datasets)

#import data from CSVs
data2010 <- read.csv('BP Apprehensions 2010.csv')
data2017 <- read.csv('BP Apprehensions 2017.csv')
ts <- read.csv('BP monthly summaries.csv')
ts1 <- ts[2:18, 2:13]

# Define UI for application


ui <- fluidPage(
  
  #title
  titlePanel("US-Mexico Boarder Patrol Apprehensions"),
  
  #sidebar where you can select the sector
  sidebarLayout(
    
    sidebarPanel(
      
      selectInput('comp', 'Choose comparison', 
                  choices = c('Monthly Summaries'= '10', 'Big Bend' = '1', 'Del Rio' = '2', 'El Centro' = '3', 'El Paso' = '4', 'Laredo' = '5', 'Rio Grande Valley' = '6', 'San Diego' = '7', 'Tuscon' = '8', 'Yuma' = '9'),
                  #choices = data2010$Sector,
                  selected = 'Big Bend'),
      
      includeText('writeup.txt')
    ),

    #Location of barplot
    mainPanel(
      tabsetPanel(
        tabPanel("Graph", plotOutput("appPlot", height = 500)),
        tabPanel("Table", tableOutput("table"))
      )
    )
  )
)

  
  
# Define server logic required to draw a histogram
server <- function(input, output) {
  
  #Reactive which processes data based on selected Sector
  selectedData <- reactive({
    if (as.numeric(input$comp) != 10){
      selected = as.numeric(input$comp)
    
      #take the selected row from each dataset 
      d1 = as.data.frame(data2010[c(selected),])
      d2 = as.data.frame(data2017[c(selected),])
      
      #Bind the data from each dataset
      mydata <- rbind(d1, d2)
    
    
      #Take out the row which lists the sector
      mydata$Sector <- NULL
      #Specify which row is which year
      rownames(mydata) <- c("2010", "2017")
      
      return(mydata)
    }
    else{
      return(ts)
    }
    
    
  })

  output$appPlot <- renderPlot({
    
    #Take reactive data
    mydata <- selectedData()
    
    if (as.numeric(input$comp) != 10){
    #Plot the data
      barplot(as.matrix(mydata), 
              beside = TRUE,
              xlab = "Months",
              ylab = "Apprehensions",
              names.arg = c("October", "November", "December", "January", "February", "March", "April", "May", "June", "July", "August", "September"),
              col = c("yellow", "blue"), 
              bty="n" )
      
          legend("topright", c("2010","2017"), pch=15,  col=c("yellow","blue"),  bty="n")
    }
    else {
      
      ts2 <- as.vector(t(ts1))
      
      ts3 <- ts(ts2, start = c(2000, 1), frequency=12)
      
      ts.plot(ts3, gpars=list(xlab="year", ylab="Apprehensions", col= 'green', lty=c(1:3)))
    }
   })
  
  output$table <- renderTable(selectedData())
}

# Run the application 
shinyApp(ui = ui, server = server)

