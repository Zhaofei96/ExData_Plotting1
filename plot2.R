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

## print the hist in png file
png(filename = "plot2.png")
plot(DT$dateTime, DT$Global_active_power, type = "l", xlab = "", ylab = "GLobal Active Power (kilowatts)")
dev.off()