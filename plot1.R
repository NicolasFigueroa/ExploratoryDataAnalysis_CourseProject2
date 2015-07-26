library(plyr)
library(ggplot2)
library(data.table)
library(grid)
library(scales)
library(httr) 

url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
PathDatos <- "data"

if(!file.exists(PathDatos)){
  dir.create(PathDatos)
}

PathGraph <- "graph" 
if(!file.exists(PathGraph)){
  dir.create(PathGraph)
}

file1 <- paste(getwd(), "/data/exdata_data_NEI_data.zip", sep = "")
if(!file.exists(file1)){
  download.file(url, file1, mode="wb")
}


file2 <- paste(getwd(), "/data/Source_Classification_Code.rds", sep = "")
if(!file.exists(file2)){
  unzip(file1,exdir = "data")
}

file3 <- paste(getwd(), "/data/summarySCC_PM25.rds", sep = "")
if(!file.exists(file3)){
  unzip(file1, exdir = "data")
}


SCC <- readRDS("data/Source_Classification_Code.rds")
NEI <- readRDS("data/summarySCC_PM25.rds")

NEI = data.table(NEI)
SCC = data.table(SCC)

totalEmission <-  <- aggregate(Emissions ~ year,NEI, sum)
names(totalEmission ) <- c("Year", "Emission")


png("graph/plot1.png", width = 480, height = 480)
barplot(
  totalEmission$Emission/10^6,
  names.arg=totalEmission$Year,
  xlab="Year",
  ylab="PM2.5 Emissions (in Tons)",
  main="Total PM2.5 Emissions in the United States"
)
dev.off()


