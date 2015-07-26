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

baltimore <- vehiclesNEI[vehiclesNEI$fips==24510,]


png("graph/plot5.png", width = 480, height = 480)

ggplot(baltimore,aes(factor(year),Emissions)) +
  geom_bar(stat="identity",fill="blue",width=0.75) +
  theme_bw() +  guides(fill=FALSE) +
  labs(x="Year", y = expression("Total Emissions of PM"[2.5])) + 
  labs(title = "Total Emissions from Motor Vehicle Sources in Baltimore City")

dev.off()