## set download variables
urlname <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
zipname <- "./data/electric.zip"
filename <- "./data/household_power_consumption.txt"

## create directory
if (!file.exists("./data")) {dir.create("./data")}

## download data
if (!file.exists(zipname)) {download.file(urlname,destfile = zipname)}

## unzip data & read file
if (!file.exists(filename)) {unzip(zipname, exdir = "./data")}

# rough estimate of how much memory the dataset will require, in GB
2075259 * 9 * 8 / 2^30 


# import data
if(!exists("hh_epc")) {
    hh_epc <- read.table(filename,
                         header = TRUE,
                         sep = ";",
                         colClasses = c(rep("character", 2), rep("numeric", times = 7)),
                         na.strings = "?",
                         comment.char = "",
                         dec = ".",
                         nrows =  2075260 )
}

if (!exists("epc")){
    # Only keep data from the dates 2007-02-01 and 2007-02-02
    epc <- hh_epc[hh_epc$Date %in% c("1/2/2007","2/2/2007"),]
    
    # convert the date and time into POSIXct format containing the date and time
    epc$DateTime <- strptime(paste(epc$Date, epc$Time), "%d/%m/%Y %H:%M:%S")
}

par(mfrow=c(2,2))

# create the first plot
plot(epc$DateTime,
     y = epc$Global_active_power, 
     type = "l",
     xlab = "",
     ylab = "Global Active Power")


# create the second plot
plot(epc$DateTime,
     y = epc$Voltage, 
     type = "l",
     xlab = "datetime",
     ylab = "Voltage")

# create the third plot
plot(epc$DateTime,
     y = epc$Sub_metering_1, 
     type = "l",
     xlab = "",
     ylab = "Energy sub metering",
     col = "Black")

lines(epc$DateTime,
      y = epc$Sub_metering_2,
      col = "Red")

lines(epc$DateTime,
      y = epc$Sub_metering_3,
      col = "Blue")

legend("topright",
       legend = c("Sub_metering_1","Sub_metering_2", "Sub_metering_3"),
       col = c("Black", "Red", "Blue"),
       lwd = 1,
       cex = .8,
       bty = "n",
       text.width = 70000)


# create the fourth plot
plot(epc$DateTime,
     y = epc$Global_reactive_power, 
     type = "l",
     xlab = "datetime",
     ylab = "Global_reactive_power")


# save the plot to png
dev.copy(png, "plot4.png", height = 480, width = 480, units = "px")
dev.off()
