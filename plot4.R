###############################################################################################################
## This program creates 4 graphs that show Global Active Power by Time, Voltage by Time, Energy Sub Metering 
##   by Time, and Global Reactive Power by Time
##   from the source data found at this URL:
##      https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip
##
## Prior to running this program, the source data set must be downloaded and unzipped into the work 
##   directory.  Also, the "setwd" command must be modified to the correct folder.
###############################################################################################################
###############################################################################################################
###############################################################################################################

###############################################################################################################
#  This section reads in and prepares the source data set
################################################################################################################
setwd("C:/Users/leedo002/Documents/Education/Data Science by JHU/Course 4 - Exploratory Data Analysis/Week 1/Project")

## Read the data set
power <- read.csv("household_power_consumption.txt",sep=";",na.strings="?"
                  ,colClasses=c("character","character","numeric","numeric","numeric","numeric","numeric","numeric","numeric")
)

## Only filter out all but the 2 subject dates
powerFebT1 <- subset(power, Date=="1/2/2007" | Date=="2/2/2007")

## Rename Date and Time variables to preserve original values,
## add a new column of POSIXlt class combining the original Date and Time variables,  
## convert the data types of the rest of the variables to numeric
powerFebT2<-mutate(powerFebT1
                   , DateTime=as.POSIXlt(strptime(paste(powerFebT1$Date,powerFebT1$Time), "%d/%m/%Y %T"),"%Y-%m-%d %T")
                   , OldDate=Date, OldTime=Time
                   , Global_active_power = as.numeric(as.character(Global_active_power))
                   , Global_reactive_power = as.numeric(as.character(Global_reactive_power))
                   , Voltage = as.numeric(as.character(Voltage))
                   , Global_intensity = as.numeric(as.character(Global_intensity))
                   , Sub_metering_1 = as.numeric(as.character(Sub_metering_1))
                   , Sub_metering_2 = as.numeric(as.character(Sub_metering_2))
                   , Sub_metering_3 = as.numeric(as.character(Sub_metering_3))
)

## Just reorder columns to create final version of source data set
powerFeb<- subset(powerFebT2,,c(DateTime,Global_active_power:Sub_metering_3,OldDate,OldTime))

###############################################################################################################
#  This section creates the required graph from the cleansed source data set
################################################################################################################

png(file="plot4.png")
par(mfrow=c(2,2))
with(powerFeb, 
     {
       # First Graph
       with(powerFeb, plot(DateTime,Global_active_power
                           ,type="l"
                           ,xlab=""
                           ,ylab="Global Active Power"
         ))
       
       # Second Graph
       with(powerFeb, plot(DateTime,Voltage, type="l"))
       
       # Third Graph
       with(powerFeb, plot(DateTime, Sub_metering_1, xlab="", ylab="Energy sub metering", type="n"))
       with(powerFeb, points(DateTime,Sub_metering_1, type="l"))
       with(powerFeb, points(DateTime,Sub_metering_2, type="l",col="red"))
       with(powerFeb, points(DateTime,Sub_metering_3, type="l",col="blue"))

       legend(  "topright"  
              , bty="n"
              , lty=1, lwd=2
              , col=c("black", "red", "blue")
              , legend=c("Sub_metering_1","Sub_metering_2","Sub_metering_3")
#              , y.intersp=0.3
             )
       
       # Fourth Graph
       with(powerFeb, plot(DateTime,Global_reactive_power,type="l"))
     }
    )
dev.off()
