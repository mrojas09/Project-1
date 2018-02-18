ts1 <- read.csv('PB monthly summaries.csv',row.names=1) #Reads in Csv

ts2 <- as.vector(t(ts1))

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

axis(1, col = 'maroon', col.axis = 'white', col.ticks = 'limegreen', cex.axis = 1.5, font = 2, family = 'mono')
axis(2, at = yticks, col = 'maroon', col.axis = 'white', col.ticks = 'limegreen', cex.axis = 0.9, font =3, family = 'mono',las=2)

abline(h = yticks, lty = 2, col = "grey26") # Horizontal line Grid
points(years, avgVec, pch = 13, col = "limegreen",lwd = 1)
text(years,avgVec,labels=yearStr, cex=0.6, pos = 3,col= "white") # Point Labels

legend(2011,250000,pch=c(13),col = "limegreen",title.adj = 0.5,title = "Legend",title.col = "grey30",text.col = "grey45",legend=c(":  Avg. Apprehension"),box.lty=2, box.lwd=2, box.col="limegreen")








