# use monthly summary
# copy the data from the screen w/o year and month

myvect <- read.csv('')

ts1 <- ts(myvect, start=c(2017, 1), frequency = 12)

plot.ts(ts1)

