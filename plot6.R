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


vehicles <- grepl("vehicle", SCC$SCC.Level.Two, ignore.case=TRUE)
vehiclesSCC <- SCC[vehicles,]$SCC
vehiclesNEI <- NEI[NEI$SCC %in% vehiclesSCC,]

vehiclesBaltimoreNEI <- vehiclesNEI[vehiclesNEI$fips == 24510,]
vehiclesBaltimoreNEI$city <- "Baltimore"
vehiclesLosAngelesNEI <- vehiclesNEI[vehiclesNEI$fips=="06037",]
vehiclesLosAngelesNEI$city <- "Los Angeles"
bothNEI <- rbind(vehiclesBaltimoreNEI,vehiclesLosAngelesNEI)


png("graph/plot6.png", width = 480, height = 480)

ggplot(bothNEI, aes(x=factor(year), y=Emissions, fill=city)) +
  geom_bar(aes(fill=year),stat="identity") +
  facet_grid(scales="free", space="free", .~city) +
  guides(fill=FALSE) + theme_bw() +
  labs(x = "Year") + labs(y = expression("Total Emissions of PM"[2.5])) +
  xlab("Year") +
  ggtitle(expression("Motor vehicle emission in Baltimore and Los Angeles"))

dev.off()