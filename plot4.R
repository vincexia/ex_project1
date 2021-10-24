library(readr)
library(dplyr)
library(datasets)

power_consumption <- read_delim("./household_power_consumption.txt", delim = ";",
                                col_names = TRUE, col_types = "ccnnnnnnn", 
                                na = c("?")) 

#Filter rows for 2007/02/01 and 2007/02/02
subset_data <- power_consumption %>% filter(Date == "1/2/2007" | Date == "2/2/2007")

# remove NA
sample_data <- subset_data[complete.cases(subset_data), ]

base_data <- sample_data %>% mutate(date_time = paste(Date, Time)) %>% 
    mutate(datetime = strptime(date_time, "%d/%m/%Y %H:%M:%S")) %>%
    mutate(date = as.Date(Date, "%d/%m/%Y")) %>%
    mutate(weekday = format(date, "%a")) 

#######################################
par(mfrow = c(2, 2))

with(base_data, {
    plot(datetime, Global_active_power, xlab = "",
         ylab = "Global Active Power", type = "l")
    
    plot(datetime, Voltage, xlab = "datetime",
         ylab = "Voltage", type = "l")
    
    plot(datetime, Sub_metering_1, xlab = "",
         ylab = "Energy sub metering",
         main = "", type = "n")
    points(datetime, Sub_metering_1, col = "black", type = "l")
    points(datetime, Sub_metering_2, col = "red", type = "l")
    points(datetime, Sub_metering_3, col = "blue", type = "l")
    legend("topright", lty = 1 , col = c("black", "red", "blue"),
           legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
    
    plot(datetime, Global_reactive_power,
         ylab = "Global_reactive_power", type = "l")
})
dev.copy(png, file = "plot4.png")
dev.off()