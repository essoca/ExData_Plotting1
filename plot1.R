
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

## Build Plot 1 and save it to png file
png(file="plot1.png", width=480, height=480)
hist(df$Global_active_power, main = "Global Active Power",
     xlab = "Global Active Power (kilowatts)", col = "red")
dev.off()