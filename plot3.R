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


baltimore <- NEI[NEI$fips=="24510",]

png("graph/plot3.png", width = 580, height = 480)

ggplot(baltimore,aes(factor(year),Emissions,fill=type)) +
  geom_bar(stat="identity") +
  theme_bw() + guides(fill=FALSE)+
  facet_grid(.~type,scales = "free",space="free") + 
  labs(x="Year", y=expression("Total PM"[2.5]*" Emission (Tons)")) + 
  labs(title=expression("PM"[2.5]*" Emissions, Baltimore City 1999-2008 by Type of Pollutant"))

dev.off()


