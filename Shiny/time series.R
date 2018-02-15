# use monthly summary
# copy the data from the screen w/o year and month

myvect = read.csv("PB monthly summaries.csv")

ts <- ts(myvect, start=c(2017, 1), end = c(2000, 13), frequency = 12)

ts1 <- read.table("clipboard", sep = "\t")
ts1

ts2 <- as.vector(t(ts1))

ts3 <- ts(ts2, start = c(2000,10), frequency=12)

ts.plot(ts3, gpars=list(xlab="year", ylab="Apprehensions", lty=c(1:3)))
