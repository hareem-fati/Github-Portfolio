                              ############################################
#Author: Hareem Fatima
#Date Created: 2024-04-26
#Date Modified: YYYY-MM-DD

# Description: This script is used to clean the data for the Intro to Gravity Report.

                             ############################################
                  #SECTION 0: INSTALLING & LOADING PACKAGES#

install.packages("readr")
library(readr)
install.packages("here")
library(here) #easy file referencing, root is set at project root
install.packages("tidyverse")
library(tidyverse)
install.packages("devtools")
library(conflicted)
devtools::install_github("r-lib/conflicted")
install.packages("dplyr")
library(dplyr)
install.packages("data.table")
library(data.table)
install.packages("reshape2")
library(reshape2)

              ######SECTION 1: Loading & Cleaning The Dynamic Trade Data######

# Loading the first trade dataset as needed
dynamic_trade_data <- readRDS("C:/Users/haree/Documents/Intro_to_Gravity_Report/input/data/usitc_dgd.rds")

#Counting the NAs in the dataset
colSums(is.na(dynamict_trade_data))  #Alot of NA values across different variables. 

#Dropping year observations before 1988
dynamic_trade_data <- dynamic_trade_data %>% filter(year > 1988)

#Dropping rows with NAs
#Useful to do so before merging
#dynamict_trade_data <- dynamict_trade_data %>% drop_na()rm

#Generating unique Pair IDs for merging datasets. 
dynamic_trade_data$pair_id <- paste(dynamic_trade_data$iso3_o, dynamic_trade_data$iso3_d, dynamic_trade_data$year, sep = "_")

            ######SECTION 2: Loading, Cleaning, and Reshaping The Second Trade Data######

rm(reshaped_itpd_trade_data)

# Loading the second trade dataset as needed
itpd_trade_data <- readRDS("C:/Users/haree/Documents/Intro_to_Gravity_Report/input/data/usitc_itpd_e_r02.rds")

#Counting the NAs in the dataset
colSums(is.na(itpd_trade_data))  #No variables with NA values

# Reshaping data by year and sector
reshaped_itpd_trade_data <- spread(itpd_trade_data, key = broad_sector, 
                                value = "trade", fill = 0)


#Counting the NAs in the reshaped dataset
colSums(is.na(reshaped_itpd_trade_data))  #No variables with NA values

#Renaming the columns
names(reshaped_itpd_trade_data)[names(reshaped_itpd_trade_data) == "Mining and Energy"] <- "Mining"


# Add a new column named 'Total_Trade' containing the sum of all sectors
reshaped_itpd_trade_data <- mutate(reshaped_itpd_trade_data, total_trade = rowSums(select(reshaped_itpd_trade_data, Mining, Agriculture, Services, Manufacturing)))


#Generating unique Pair IDs for merging datasets. 
reshaped_itpd_trade_data$pair_id <- paste(reshaped_itpd_trade_data$exporter_iso3, reshaped_itpd_trade_data$importer_iso3, reshaped_itpd_trade_data$year, sep = "_")
    
  
             ######SECTION 3: Merging The Two Trade Datasets To Form Combined Sectoral-Level Data######

rm(trade_data_sector_consolidated)

#Merging the two datasets
trade_data_sector_consolidated <- merge(dynamic_trade_data, reshaped_itpd_trade_data, by = "pair_id", all = TRUE)

#Counting the NAs in the reshaped dataset
colSums(is.na(trade_data_sector_consolidated))  #A lot of vars with NA values

#trade_data_sector_consolidated <- trade_data_sector_consolidated %>% drop_na()

#Droping the year.y variable
trade_data_sector_consolidated <- trade_data_sector_consolidated %>% select(-year.y)

#Saving the trade_data_sector_consolidated
saveRDS(trade_data_sector_consolidated, "C:/Users/haree/Documents/Intro_to_Gravity_Report/output/Output data/trade_data_sector_consolidated.rds")

            ######SECTION 4: Transforming The Dynamic Trade Dataset To Form A Non-Sectoral Country Trade######


    ######SECTION 4: Transforming The Dynamic Trade Dataset To Form A Non-Sectoral Country Trade######

#Reshaping the data from sectoral-level to country-level trade data
country_level_trade_data <- itpd_trade_data %>%
  group_by(importer_iso3, exporter_iso3, year) %>%  # Group by origin, destination country, and year
  summarise(total_trade = sum(trade))  # Sum trade value for each country pair and year

#Checking Missing NAs
colSums(is.na(country_level_trade_data))  #No variables with NA values

# Generating Pair_ID to represent the unique identifier for each observation
country_level_trade_data$pair_id <- paste(country_level_trade_data$exporter_iso3, 
                                          country_level_trade_data$importer_iso3, 
                                          country_level_trade_data$year, sep = "_")

#Merging country level data with the ITDP data to construct country-level trade data
trade_data_consolidated <- merge(dynamict_trade_data, country_level_trade_data, by = "pair_id", all = TRUE)

#Checking Missing NAs
colSums(is.na(trade_data_consolidated))  #A lot of vars with NA values


##Dropping Observations with NAs
trade_data_consolidated <- trade_data_consolidated %>% drop_na()


##Saving Country-Level Trade Data
saveRDS(trade_data_consolidated, "C:/Users/haree/Documents/Intro_to_Gravity_Report/output/Output data/trade_data_consolidated.rds")