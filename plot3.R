
library(dplyr)

# Function to read the data
readData <- function(filename){
  ## filename is where the data is stored
  ## Returns a dataframe with the data for "2007-02-01" and "2007-02-02"
  
  colNames <- unlist(strsplit(readLines(filename, 1), ";")) 
  data <- read.table(filename, sep = ";", stringsAsFactors = FALSE, na.strings = "?",
                     col.names = colNames,
                     colClasses = c(rep("character",2), rep("numeric",7)), skip = 1)
  df <- mutate(tbl_df(data), DateTime = paste(Date, Time, sep = " ")); rm("data")
  df <- select(df, DateTime, Global_active_power:Sub_metering_3)
  df$DateTime <- strptime(df$DateTime, format = "%d/%m/%Y %H:%M:%S")
  dates <- as.Date(df$DateTime)
  df[which(dates == as.Date("2007-02-01") | dates == as.Date("2007-02-02")), ]
}

## Read the data
df <- readData("household_power_consumption.txt")

## Build Plot 3 and save it to png file
png(file="plot3.png", width=480, height=480)
plot(df$DateTime, df$Sub_metering_1, xlab = "",  ylab = "Energy sub metering", type="n")
points(df$DateTime, df$Sub_metering_1, type = "l", col = "black")
points(df$DateTime, df$Sub_metering_2, type = "l", col = "red")
points(df$DateTime, df$Sub_metering_3, type = "l", col = "blue")
legend("topright", lty = 1, col = c("black", "red", "blue"),
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
dev.off()
