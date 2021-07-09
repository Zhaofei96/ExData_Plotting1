library(data.table)
fileName <- "exdata_data_household_power_consumption.zip"
if(!file.exists(fileName)){
        fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
        download.file(fileUrl, fileName, method = "curl")
}

if(!file.exists("household_power_consumption.txt")){
        unzip(fileName)
}

## Read the file
DTall <- data.table::fread("household_power_consumption.txt", na.strings = "?")  ##, na.strings = "?"

## change the format: date into date; Global_active_power into numer
DTall[, dateTime := as.POSIXct(paste(Date, Time), format = "%d/%m/%Y %H:%M:%S")]
DTall[, Global_active_power := lapply(.SD, as.numeric), .SDcols = "Global_active_power"]

## SUbset the data between "2007-02-01" and "2007-02-02"
DTall[, Date := lapply(.SD, as.Date, "%d/%m/%Y"), .SDcols = "Date"]
DT <- DTall[(DTall$Date >= "2007-02-01")&(DTall$Date <= "2007-02-02")] 

## change sub metering to numeric data
DTall[, c("Sub_metering_1","Sub_metering_2", "Sub_metering_3", 
          "Voltage", "Global_reactive_power") := 
              lapply(.SD, as.numeric), .SDcols = c("Sub_metering_1",
                                                   "Sub_metering_2", "Sub_metering_3", 
                                                   "Voltage", "Global_reactive_power")]

## print the figures into plot4.png
png("plot3.png")

plot(DT$dateTime, DT$Sub_metering_1, type = "l", ylab = "Energy sub metering", xlab = "")
lines(DT$dateTime, DT$Sub_metering_2,type = "l", col = "red")
lines(DT$dateTime, DT$Sub_metering_3,type = "l", col = "blue")
legend("topright", col = c("black", "red", "blue"), lty=1, 
       legend = c("Sub_metering_1","Sub_metering_2", "Sub_metering_3"))

dev.off()