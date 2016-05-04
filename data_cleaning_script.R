setwd("C:/Users/Frank/coursera/datascience/homework/shiny")

raw_data <- read.table("namq_nace10_e.tsv", header=TRUE, sep="\t", dec=".", fill = TRUE, na.strings = ": ")

raw_data <- data.frame(raw_data)

raw_data$unit.nace_r2.s_adj.indic_na.geo.time <- as.character(raw_data$unit.nace_r2.s_adj.indic_na.geo.time)
raw_data[,2:139] <- mapply(function(x) as.double(as.character(x)), raw_data[,2:139])

get_unit <- function(x) strsplit(x, ",")[[1]][1]
raw_data$unit <- mapply(get_unit, raw_data[,1])

get_nace <- function(x) strsplit(as.character(x), ",")[[1]][2]
raw_data$nace_r2 <- mapply(get_nace, raw_data[,1])

get_s_adj <- function(x) strsplit(as.character(x), ",")[[1]][3]
raw_data$s_adj <- mapply(get_s_adj, raw_data[,1])

get_indic_na <- function(x) strsplit(as.character(x), ",")[[1]][4]
raw_data$indic_na <- mapply(get_indic_na, raw_data[,1])

get_geo <- function(x) strsplit(as.character(x), ",")[[1]][5]
raw_data$geo <- mapply(get_geo, raw_data[,1])

raw_data[,1] <- NULL
#raw_data[,139:143] <- mapply(as.factor, raw_data[,139:143])

country_codes <- as.vector(unique(raw_data$geo))
country_codes <- setdiff(country_codes, c("EA","EA12","EA17","EA18","EU15","EU27","EU28"))
saveRDS(country_codes, file="country_codes_noagg.rds")

saveRDS(raw_data, file="namq_nace10.rds")
raw_data <- raw_data[which(raw_data$geo %in% country_codes),]

saveRDS(raw_data, file="namq_nace10_noagg.rds")

nace_lookup <- read.table("nace.csv", sep=",")
unit_lookup <- read.table("unit_measure.csv", sep = ",")
seasons_lookup <- read.table("seasons.csv", sep=",")
indicator_lookup <- read.table("indicators.csv", sep=",")

