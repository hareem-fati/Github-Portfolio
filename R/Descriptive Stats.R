                       ############################################
#Author: Hareem Fatima
#Date Created: 26-04-2024
#Date Modified: 10-05-2024

# Description: Generating Graphs & Summary Stats for the Trade Data
# This script generates graphs and summary statistics for the trade data.
                      ############################################
                            
          ###SECTION 1: LOADING & INSTALLING RELEVANT PACKAGES & LIBRARIES###
                       
                            
install.packages("readr")
library(readr)
install.packages("here")
library(here) #easy file referencing, root is set at project root
install.packages("tidyverse")
library(conflicted)
library(dplyr)
library(tidyverse)
devtools::install_github("r-lib/conflicted")
install.packages("ggplot2")
library(ggplot2)
install.packages("ggthemes")
library(ggthemes)
install.packages("scales")
library(scales)
install.packages("gridExtra")
library(gridExtra)
install.packages("labelled")
install.packages("readxl")
library(readxl)

#Loading The Data
trade_data_consolidated <- readRDS("C:/Users/haree/Documents/Intro_to_Gravity_Report/output/Output data/trade_data_consolidated.rds")

           ###SECTION 2: ECUADOR'S TRADE EVOLUTION WITH CHILE###

ecuador <- trade_data_consolidated %>% filter(country_o == "Ecuador") #Filtering Data for Ecuador

#Counting Missing Columns In Ecuador Data
colSums(is.na(ecuador))  

#Dropping Missing observations In Ecuador Data For total_trade variable
ecuador <- ecuador %>% drop_na(total_trade)

# Ecuador's Exports: Total Trade Value - Variable
ecuador_exports_total <- ecuador %>%
  summarise(total_trade = sum(total_trade))

#Ecudor's Exports to Chile
ecuador_exports_chile <- ecuador %>%
  filter(country_o == "Ecuador" & country_d == "Chile") %>%
  summarise(total_trade = sum(total_trade))

#Ecuador's Exports to Chile As a Percent of Total Exports
ecuador_exports_chile_percent <- (ecuador_exports_chile / ecuador_exports_total)*100

#Trade share b/w Ecuador and Chile
print(ecuador_exports_chile_percent)

#Generating a data frame for Ecuador's Trade With Chile
ecuador_trade_evolution <- trade_data_consolidated %>%
  filter(country_o == "Ecuador" & country_d == "Chile")

# Creating bilateral trade relations Graph between Ecuador and Chile
ecudar_chile<- ggplot(ecuador_trade_evolution, aes(x = year.x, y = total_trade)) +  
geom_line(color = "blue")  # Add geom_line() back with desired color
ecudar_chile<-ecudar_chile+ggtitle('Trade Evolution between Ecuador and Chile')
ecudar_chile<-ecudar_chile+labs(x="Year", y=expression(paste("Total Trade Value (USD Million)"), title="Trade Evolution between Ecuador and Chile"))
ecudar_chile<-ecudar_chile+theme_minimal()

print(ecudar_chile)

                      ###SECTION 3: CHILE'S TRADE EVOLUTION WITH ECUADOR###

chile <- trade_data_consolidated %>% filter(country_o == "Chile")  #Filtering Data for Chile

#Dropping Missing observations In Chile Data For total_trade variable
chile <- chile %>% drop_na(total_trade)

#Chile's Exports: Total Trade Value - Variable
chile_exports_total <- chile %>%
  summarise(total_trade = sum(total_trade))

#Chile's Exports to Ecuador
chile_exports_ecuador <- chile %>%
  filter(country_o == "Chile" & country_d == "Ecuador") %>%
  summarise(total_trade = sum(total_trade))

#Chile's Exports to Ecuador As a Percent of Total Exports
chile_exports_ecuador_percent <- (chile_exports_ecuador / chile_exports_total)*100

#Trade share b/w Chile and Ecuador
print(chile_exports_ecuador_percent)

#Generating a data frame for Ecuador's Trade With Chile
chile_trade_evolution <- trade_data_consolidated %>%
  filter(country_o == "Chile" & country_d == "Ecuador")

# Creating bilateral trade relations Graph between Chile and Ecuador
chile_ecuador<- ggplot(chile_trade_evolution, aes(x = year.x, y = total_trade)) +  
geom_line(color = "blue")  # Add geom_line() back with desired color
chile_ecuador<-chile_ecuador+ggtitle('Trade Evolution between Chile and Ecuador')
chile_ecuador<-chile_ecuador+labs(x="Year", y=expression(paste("Total Trade Value (USD Million)"), title="Trade Evolution between Ecuador and Chile"))
chile_ecuador<-chile_ecuador+theme_minimal()

print(chile_ecuador)

                ###SECTION 4: CHILE'S TRADE EVOLUTION WITH MAIN TRADING PARTNERS###

#Defining the dataset for Chile's main trade partners
chile_main_trade_partners <- chile %>%
  filter(country_o == "Chile", country_d %in% c("Japan", "United States", "China", "Korea, South", "United Kingdom")) 

#Dropping Missing observations In Chile Data For total_trade variable
chile_main_trade_partners <- chile_main_trade_partners %>% drop_na(total_trade)

#Renaming the country_d variable to Importer
chile_main_trade_partners <- rename(chile_main_trade_partners, Importer = country_d)

# Create the ggplot object with proper axis labels
chile_trade_partners <- ggplot(chile_main_trade_partners, aes(x = year.x, y = total_trade, color = Importer)) +
geom_line() 
chile_trade_partners<- chile_trade_partners + scale_color_manual(values = c("red", "blue", "green", "purple", "orange"))
chile_trade_partners<-chile_trade_partners+ggtitle('Trade Evolution b/w Chile & Main Trade Partners')
chile_trade_partners<-chile_trade_partners+labs(x="Year", y=expression(paste("Total Trade Value (USD Million)"), title="Trade b/w Chile & Main Trade Partners"))
chile_trade_partners<-chile_trade_partners+theme_minimal()

print(chile_trade_partners)  #printing the graph


                ###SECTION 5: ECUADOR'S TRADE EVOLUTION WITH MAIN TRADING PARTNERS###

#Defining the dataset for Ecuador's main trade partners
ecuador_main_trade_partners <- trade_data_consolidated %>%
  filter(country_o == "Ecuador", country_d %in% c("Peru", "United States", "China", "Panama", "Russia")) 

#Dropping Missing observations In Ecuador Data For total_trade variable
ecuador_main_trade_partners <- ecuador_main_trade_partners %>% drop_na(total_trade)

#Renaming the country_d variable to Importer
ecuador_main_trade_partners <- rename(ecuador_main_trade_partners, Importer = country_d)


# Create the ggplot object with proper axis labels
ecuador_trade_partners <- ggplot(ecuador_main_trade_partners, aes(x = year.x, y = total_trade, color = Importer)) +
  geom_line() 
ecuador_trade_partners<- ecuador_trade_partners + scale_color_manual(values = c("red", "blue", "green", "purple", "orange"))
ecuador_trade_partners<-ecuador_trade_partners+ggtitle('Trade b/w Ecuador & Main Trade Partners')
ecuador_trade_partners<-ecuador_trade_partners+labs(x="Year", y=expression(paste("Total Trade Value (USD Million)"), title="Trade b/w Ecuador & Main Trade Partners"))
ecuador_trade_partners<-ecuador_trade_partners+theme_minimal()

print(ecuador_trade_partners)  #printing the graph

                                  ###TRADE SHARE & GRAPHS###

rm(trade_share, trade_share_ecuador_chile, trade_share_chile_main_trade_partners, trade_share_ecuador_main_trade_partners, trade_share_ecuador_chile_graph)

rm(trade_share, trade_share_ecuador, trade_share_ecuador_chile_graph)

rm(trade_share)
rm(trade_share_ecuador)

#remove NA values from total_trade in trade_data_consolidated
trade_data_consolidated <- trade_data_consolidated %>% drop_na(total_trade)

#Creating a dataset for trade share
trade_share <- trade_data_consolidated %>%
  group_by(country_o, country_d, year.x) %>%
  summarise(total_trade = sum(total_trade)) %>%
  mutate(Trade_Share = (total_trade / sum(total_trade)*100))


#Creating a dataset for trade share b/w Ecuador and Chile
trade_share_ecuador <- trade_share %>%
  filter(Exporter %in% c("Ecuador") & country_d == "Chile") %>%
  group_by(Exporter, country_d, year.x) %>%
  summarise(total_trade = sum(total_trade)) %>%
  mutate(Trade_Share = (total_trade / sum(total_trade)*100))

#Creating a dataset for trade share b/w Chile and Ecuador
trade_share_ecuador <- trade_share %>%
  filter(Exporter %in% c("Chile") & country_d == "Ecuador") %>%
  group_by(Exporter, country_d, year.x) %>%
  summarise(total_trade = sum(total_trade)) %>%
  mutate(Trade_Share = (total_trade / sum(total_trade)*100))

#Creating a graph for trade share of Chile to Ecuador
trade_share_chile_ecuador_graph <- ggplot(trade_share_ecuador, aes(x = year.x, y = Trade_Share, color = Exporter)) +
  geom_line() +
  scale_color_manual(values = c("red", "blue")) +
  ggtitle("Trade Share of Chile to Ecuador") +
  labs(x = "Year", y = "% of Trade Share", title = "Trade Share of Chile to Ecuador") +
  theme_minimal()
print(trade_share_chile_ecuador_graph)

#Creating a graph for trade share of Ecuador to Chile
trade_share_ecuador_chile_graph <- ggplot(trade_share_ecuador, aes(x = year.x, y = Trade_Share, color = Exporter)) +
  geom_line() +
  scale_color_manual(values = c("red", "blue")) +
  ggtitle("Trade Share of Ecuador to Chile") +
  labs(x = "Year", y = "% of Trade Share", title = "Trade Share of Ecuador to Chile") +
  theme_minimal()
print(trade_share_ecuador_chile_graph)

#Creating a dataset for trade share b/w Chile and main trade partners
trade_share_chile_main_trade_partners <- trade_share %>%
  filter(Exporter %in% c("Chile") & Importer %in% c("Japan", "United States", "China", "Korea, South", "United Kingdom")) %>%
  group_by(Exporter, Importer, year.x) %>%
  summarise(total_trade = sum(total_trade)) %>%
  mutate(Trade_Share = (total_trade / sum(total_trade)*100))

#Creating a graph for trade share of Chile to main trade partners
trade_share_chile_main_trade_partners_graph <- ggplot(trade_share_chile_main_trade_partners, aes(x = year.x, y = Trade_Share, color = Importer)) +
  geom_line() +
  scale_color_manual(values = c("red", "blue", "green", "purple", "orange")) +
  ggtitle("Trade Share of Chile to Main Trade Partners") +
  labs(x = "Year", y = "% of Trade Share", title = "Trade Share of Chile to Main Trade Partners") +
  theme_minimal()

print(trade_share_chile_main_trade_partners_graph)

#Creating a dataset for trade share b/w Ecuador and main trade partners
trade_share_ecuador_main_trade_partners <- trade_share %>%
  filter(Exporter %in% c("Ecuador") & Importer %in% c("Peru", "United States", "China", "Panama", "Russia")) %>%
  group_by(Exporter, Importer, year.x) %>%
  summarise(total_trade = sum(total_trade)) %>%
  mutate(Trade_Share = (total_trade / sum(total_trade)*100))

#Creating a graph for trade share of Ecuador to main trade partners
trade_share_ecuador_main_trade_partners_graph <- ggplot(trade_share_ecuador_main_trade_partners, aes(x = year.x, y = Trade_Share, color = Importer)) +
  geom_line() +
  scale_color_manual(values = c("red", "blue", "green", "purple", "orange")) +
  ggtitle("Trade Share of Ecuador to Main Trade Partners") +
  labs(x = "Year", y = "% of Trade Share", title = "Trade Share of Ecuador to Main Trade Partners") +
  theme_minimal()

print(trade_share_ecuador_main_trade_partners_graph)