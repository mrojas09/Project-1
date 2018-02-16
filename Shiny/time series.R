# use monthly summary
# copy the data from the screen w/o year and month

ts1 <- read.csv('BP monthly summaries.csv')
show(ts1)

year <- as.vector(ts1['year'])

ts1 <- ts1[2:18, 2:13]

ts2 <- as.vector(t(ts1))

ts3 <- ts(ts2, start = c(2000, 1), frequency=12)

ts.plot(ts3, gpars=list(xlab="year", ylab="Apprehensions", col= 'green', lty=c(1:3)))

text(ts3, labels = as.character(year), cex = 0.7)
