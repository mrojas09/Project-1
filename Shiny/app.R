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
ts1 <- read.csv('PB monthly summaries.csv',row.names=1) #Reads in Csv
ts2 <- as.vector(t(ts1))


# Define UI for application

ui <- fluidPage(
  
  #title
  titlePanel("US-Mexico Boarder Patrol Apprehensions"),
  
  #sidebar where you can select the sector
  sidebarLayout(
    
    sidebarPanel(
      
      selectInput('comp', 'Choose comparison', 
                  choices = c('Monthly Summaries'= '10', 'Big Bend' = '1', 'Del Rio' = '2', 'El Centro' = '3', 'El Paso' = '4', 'Laredo' = '5', 'Rio Grande Valley' = '6', 'San Diego' = '7', 'Tuscon' = '8', 'Yuma' = '9'),
                  selected = 'Big Bend')
      
     # includeText('writeup.txt')
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
      return(ts1) # else returns summary data
    }
    
    
  })
  
  output$appPlot <- renderPlot({
    
    #Take reactive data
    mydata <- selectedData()
    
    if (as.numeric(input$comp) != 10){
      #Plot the data
      
      months <- c("October", "November", "December", "January", "February", "March", "April", "May", "June", "July", "August", "September")
      par(bg = "black") # Plot Background Color
      
      barplot(as.matrix(mydata),main = "2010/2017 US. Apprehensions", beside = TRUE, xlab = "Months", ylab = "Apprehensions",
        names.arg = months, 
        col = c("limegreen", "maroon"), col.main = "white", font.main = 2,family = "mono", bty="n",axes = FALSE)
    
      xTicks <- c(2,5,8,11,14,17,20,23,26,29,32,35) # x Axis tick mark positions
      
      #Custom x and y axis
      axis(1, at = xTicks, labels = months, col = 'maroon', col.axis = 'white', col.ticks = 'limegreen', cex.axis = 0.9, font = 2, family = 'mono',las=2)
      axis(2, col = 'maroon', col.axis = 'white', col.ticks = 'limegreen', cex.axis = 0.9, font =3, family = 'mono',las=2)
      
      legend("topright",legend=c(":  2010", ":  2017"), fill = c("limegreen","maroon"), xjust = 0, title.adj = 0.5,title = "Legend",title.col = "grey30",
             text.col = "grey45",box.lty=2, box.lwd=2, box.col="limegreen")
      grid(nx = NA, ny = NULL, col = "grey26", lty = 2)
    }
    else {
      
      
      ts3 <- ts(rev(ts2), start = c(2000, 1), frequency=12)
      
      mat <- as.matrix(ts1)
      
      avg_lst <- list() # List used to append the averages of each year 
      for (i in 1:18){
        element <- mean(mat[i,])
        avg_lst <- c(avg_lst,element)
      }
      
      avgVec <- as_vector(rev(avg_lst)) 
      years <- c(2000:2017) #  will be used as a paramter for the points
      yearStr <- as.character(years) # Conversion of proir vector to Strings to be used as labels
      
      par(bg = "black")
      ts.plot(ts3, gpars=list(main = "US Apprehensions Yearly Summary", col.main = "white", font.main = 2,family = "mono",xlab="Year", ylab="Apprehensions",xlim = c(2000,2017), ylim = c(0,250000),pch = 19,axes = FALSE,col= 'maroon', lwd=2,lty=c(1:3)))
      yticks <- seq(50000, 200000, 20000) # y Axis Bounds incrementing by 20k
      
      #Custom x and y axis
      axis(1, col = 'maroon', col.axis = 'white', col.ticks = 'limegreen', cex.axis = 1.5, font = 2, family = 'mono')
      axis(2, at = yticks, col = 'maroon', col.axis = 'white', col.ticks = 'limegreen', cex.axis = 0.9, font =3, family = 'mono',las=2)
      
      abline(h = yticks, lty = 2, col = "grey26") # Horizontal line Grid
      
      # Mean apprehensions per year
      points(years, avgVec, pch = 13, col = "limegreen",lwd = 1)
      text(years,avgVec,labels=yearStr, cex=0.6, pos = 3,col= "white") # Point Labels
      
      legend(2011,250000,pch=c(13),col = "limegreen",title.adj = 0.5,title = "Legend",title.col = "grey30",text.col = "grey45",legend=c(":  Avg. Apprehension"),box.lty=2, box.lwd=2, box.col="limegreen")
      
    }
  })
  
  output$table <- renderTable(selectedData())
}

# Run the application 
shinyApp(ui = ui, server = server)

