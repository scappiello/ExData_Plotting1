# Load household power consumption data file
datafile = "household_power_consumption.txt"

# Read headers from the file
#   Note: not using read.table with header = TRUE because we want to skip many rows in the file
f = file(datafile, open = "rt")
firstline = readLines(f, n = 1)
close(f)

headers = strsplit(firstline, ";")[[1]]

# Calculate row numbers to read in.  Assumes data is sorted by date/time.
#   1 row for column names
#   396 rows for observations from 2006-12-17
#   1440 rows per day thereafter (24 hours x 60 minutes x 1 observation per minute)
#   46 days to skip until 2007-02-01
#   2 days of data to load
skiprows = 1 + 396 + 1440*46
readrows = 1440*2

# Read in data from file as a dataframe
#   Date and Time columns are read as characters so they can later be converted to POSIXlt
#   Skip the header row and all other rows before 2007-02-01
dfPower = read.table(datafile, 
                     header = FALSE, 
                     sep = ";",
                     col.names = headers,
                     colClasses = c("character", "character", "numeric", "numeric", 
                                    "numeric", "numeric", "numeric", "numeric", "numeric"),
                     na.strings = c("?", "??"),
                     skip = skiprows,
                     nrows = readrows)

# Add new column for DateTime (POSIXlt) from Date and Time
dfPower$DateTime = strptime(paste(dfPower$Date, dfPower$Time), format = "%d/%m/%Y %H:%M:%S")

# Create Plot 4
par(ps = 12)
par(mfrow = c(2, 2))
par(mar = c (4, 4, 4, 2))
plot(dfPower$DateTime, dfPower$Global_active_power, 
     type = "l",
     xlab = "",
     ylab = "Global Active Power")

plot(dfPower$DateTime, dfPower$Voltage,
     type = "l",
     xlab = "datetime",
     ylab = "Voltage")

plot(dfPower$DateTime, dfPower$Sub_metering_1, col = "black",
     type = "l",
     xlab = "",
     ylab = "Energy sub metering")
lines(dfPower$DateTime, dfPower$Sub_metering_2, col = "red")
lines(dfPower$DateTime, dfPower$Sub_metering_3, col = "blue")
legend("topright", NULL,
       c("Sub_metering_1  ", "Sub_metering_2  ", "Sub_metering_3  "),
       bty = "n",
       y.intersp = 0.7,
       lty = c(1, 1, 1),
       lwd = c(2, 2, 2),
       col = c("black", "red", "blue"))

plot(dfPower$DateTime, dfPower$Global_reactive_power,
     type = "l",
     xlab = "datetime",
     ylab = "Global_reactive_power")

# Copy to PNG file
dev.copy(png, file = "plot4.png")
dev.off()
