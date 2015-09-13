# Exploratory Data Analysis
# R code to create plot4.png

# Set start and end dates for analysis

d0 <- as.Date("2007-02-01")
d1 <- as.Date("2007-02-02")

# File name
xfil <- "household_power_consumption.txt"

# Read data
# Work out lines of data to skip: start at n0, finish at n1
n    <- 1
rowN <- read.table(xfil,header=FALSE,nrows=1,sep=";")
x    <- read.table(xfil,header=FALSE,skip=1,nrows=1,sep=";")
curr <- as.Date(as.character(x[1,1]),"%d/%m/%Y")
hour <- as.numeric(substr(as.character(x[1,2]),1,2))
mins <- as.numeric(substr(as.character(x[1,2]),4,5))
n0   <- as.numeric( (d0-curr)*24*60 ) - 60*hour - mins + 2
n1   <- as.numeric( (d1+1-curr)*24*60 ) - 60*hour - mins + 1

x    <- read.table(xfil,header=FALSE,skip=n0-1,nrows=n1-n0+1,sep=";")

for( i in 1:ncol(x) ){
  names(x)[i] <- as.character(rowN[1,i])
}

# Plot graph 4: 2 row x 2 column plot array 
#  (1,1): time-series plot of Global Active Power (kw)
#  (1,2): time-series plot of Voltage
#  (2,1): time-series plot of Energy sub metering
#  (2,2): time-series plot of Global reactive power

# Make my.time variable out of available "Date" and "Time" variables
my.time   <- paste( as.character(x$Date), as.character(x$Time) )
my.time   <- strptime(my.time, "%d/%m/%Y %H:%M:%S")
x$my.time <- my.time
rm(my.time)

# set up 4x4 array
par(mfrow=c(2,2))

# (1,1)
main <- ""
xlab <- ""
ylab <- "Global Active Power"
with(x, plot(my.time,Global_active_power,main=main,xlab=xlab,ylab=ylab,type="l"))

# (1,2)
main <- ""
xlab <- "datetime"
ylab <- "Voltage"
with(x, plot(my.time,Voltage,main=main,xlab=xlab,ylab=ylab,type="l"))

# (2,1)
main <- ""
xlab <- ""
ylab <- "Energy sub metering"
col  <- c("black","red","blue")
with(x, {
  plot( my.time,Sub_metering_1,main=main,xlab=xlab,ylab=ylab,col=col[1],type="l")
  lines(my.time,Sub_metering_2,col=col[2])
  lines(my.time,Sub_metering_3,col=col[3])
})
legend("topright",
       legend=names(x)[7:9],
       lty=rep(1,3),
       col=col,
       bty="n")
#legend=paste(names(x)[7:9],"          "),

# (2,2)
main <- ""
xlab <- "datetime"
#ylab <- "Global reactive Power"
with(x, plot(my.time,Global_reactive_power,main=main,xlab=xlab,type="l"))

# Plot 4 to png device
dev.copy(png,file="plot4.png",width=480,height=480,bg="white")
dev.off()





