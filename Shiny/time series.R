# use monthly summary
# copy the data from the screen w/o year and month

ts <- readClipboard(raw = FALSE)

ts1 <- read.table("clipboard", sep = "\t")
ts1

ts2 <- as.vector(t(ts1))

ts3 <- ts(ts2, start = c(2000,10), frequency=12)

ts.plot(ts3, gpars=list(xlab="year", ylab="Apprehensions", lty=c(1:3)))
