data2010 <- read.csv('BP Apprehensions 2010.csv')
data2017 <- read.csv('PB Apprehensions 2017.csv')


colu = as.numeric('1')
d1 = as.data.frame(data2010[c(colu),])

#colnames(d1) <- c("January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December")
d2 = as.data.frame(data2017[c(colu),])

#colnames(d2) <- c("January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December")

mydata <- rbind(d1, d2)
mydata$Sector <- NULL
rownames(mydata) <- c("2010", "2017")
mydata

barplot(as.matrix(mydata), 
        beside = TRUE,
        xlab = "Months",
        ylab = "Apprehensions",
        names.arg = c("October", "November", "December", "January", "February", "March", "April", "May", "June", "July", "August", "September"),
        col = c("yellow", "blue"), 
        bty="n" )
        legend("topright", c("2010","2017"), pch=15,  col=c("yellow","blue"),  bty="n")

