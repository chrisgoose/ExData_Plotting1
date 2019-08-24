#Dataset: Electric power consumption [20Mb]
#Description: Measurements of electric power consumption in one household with a
#one-minute sampling rate over a period of almost 4 years. Different electrical
#quantities and some sub-metering values are available.

#The following descriptions of the 9 variables in the dataset are taken from the
#UCI web site:
        #Date: Date in format dd/mm/yyyy
        #Time: time in format hh:mm:ss
        #Global_active_power: household global minute-averaged active power (in kilowatt)
        #Global_reactive_power: household global minute-averaged reactive power (in kilowatt)
        #Voltage: minute-averaged voltage (in volt)
        #Global_intensity: household global minute-averaged current intensity (in ampere)
        #Sub_metering_1: energy sub-metering No. 1 (in watt-hour of active energy).
                        #It corresponds to the kitchen, containing mainly a dishwasher,
                        #an oven and a microwave (hot plates are not electric but gas powered).
        #Sub_metering_2: energy sub-metering No. 2 (in watt-hour of active energy).
                        #It corresponds to the laundry room, containing a washing-machine,
                        #a tumble-drier, a refrigerator and a light.
        #Sub_metering_3: energy sub-metering No. 3 (in watt-hour of active energy).
                        #It corresponds to an electric water-heater and an air-conditioner.


url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
if(!file.exists("dataset.zip")) {
        download.file(url, "dataset.zip", method="curl")
}
if(!file.exists("household_power_consumption")){
        unzip("dataset.zip")
}

power <- read.table("household_power_consumption.txt", header = TRUE, sep=";", na.strings="?")
subPower <- subset(power,power$Date=="1/2/2007" | power$Date =="2/2/2007")
subPower$Date <- as.Date(subPower$Date, format = "%d/%m/%Y")
subPower$Time <- strptime(subPower$Time, format="%H:%M:%S")
subPower[1:1440,"Time"] <- format(subPower[1:1440,"Time"],"2007-02-01 %H:%M:%S")
subPower[1441:2880,"Time"] <- format(subPower[1441:2880,"Time"],"2007-02-02 %H:%M:%S")

png("plot1.png")
hist(subPower$Global_active_power, col="red", main="Global Active Power", xlab="Global Active Power (kilowatts)")
dev.off()

png("plot2.png")
with(subPower, plot(Time, Global_active_power, type = "l", xlab="", ylab="Global Active Power (kilowatts)"))
dev.off()

png("plot3.png")
with(subPower, plot(Time, Sub_metering_1, type = "n" ,xlab= "", ylab= "Energy sub metering"))
with(subPower, lines(Time, Sub_metering_1))
with(subPower, lines(Time, Sub_metering_2, col = "red"))
with(subPower, lines(Time, Sub_metering_3, col = "blue"))
legend("topright", lty = 1, col = c("black", "red", "blue"), legend = c("Sub_metering_1", "Subt_metering_2", "Sub_metering_3"))
dev.off()

png("plot4.png")
par(mfrow=c(2,2))
with(subPower, plot(Time, Global_active_power, type = "l", xlab= "", ylab = "Global Active Power"))
with(subPower, plot(Time, Voltage, type = "l", xlab= "datetime", ylab = "Voltage"))
with(subPower, plot(Time, Sub_metering_1, type = "n" , xlab= "", ylab = "Energy sub metering"))
with(subPower, lines(Time, Sub_metering_1))
with(subPower, lines(Time, Sub_metering_2, col = "red"))
with(subPower, lines(Time, Sub_metering_3, col = "blue"))
legend("topright", lty = 1, col = c("black", "red", "blue"), legend = c("Sub_metering_1", "Subt_metering_2", "Sub_metering_3"))
with(subPower, plot(Time, Global_reactive_power, type = "l", xlab= "datetime", ylab = "Global Reactive Power"))
dev.off()