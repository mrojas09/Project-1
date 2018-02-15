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
data2017 <- read.csv('PB Apprehensions 2017.csv')


# Define UI for application


ui <- fluidPage(
  
  #title
  titlePanel("Boarder Patrol Apprehensions by Sector in 2010 and 2017"),
  
  #sidebar where you can select the sector
  sidebarLayout(
    
    sidebarPanel(
      
      selectInput('comp', 'Choose comparison', 
                  choices = c('Big Bend' = '1', 'Del Rio' = '2', 'El Centro' = '3', 'El Paso' = '4', 'Laredo' = '5', 'Rio Grande Valley' = '6', 'San Diego' = '7', 'Tuscon' = '8', 'Yuma' = '9'),
                  #choices = data2010$Sector,
                  selected = 'Big Bend'),
      
      imageOutput('writeup.pdf', width = 500, height = 500)
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
    
  })

  output$appPlot <- renderPlot({
    
    #Take reactive data
    mydata <- selectedData()
    
    #Plot the data
    barplot(as.matrix(mydata), 
            beside = TRUE,
            xlab = "Months",
            ylab = "Apprehensions",
            names.arg = c("October", "November", "December", "January", "February", "March", "April", "May", "June", "July", "August", "September"),
            col = c("yellow", "blue"), 
            bty="n" )
    
        legend("topright", c("2010","2017"), pch=15,  col=c("yellow","blue"),  bty="n")
     
   })
  
  output$table <- renderTable(selectedData())
}

# Run the application 
shinyApp(ui = ui, server = server)

