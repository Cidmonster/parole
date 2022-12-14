setwd("~/Dropbox/Prisons and parole/parole/")
library(dplyr)
library(tidyr)
library(tibble)
library(readr)
library(purrr)
library(readr)

prisoners <- read.table("Parole files/press2.txt", sep = '\t',header = F)


prisoners <- separate(prisoners, V1, c("idnum","stuff"), sep = 9, remove = FALSE)
prisoners <- prisoners %>% filter(stuff != '' & idnum != '') %>%  arrange(stuff) 


#Calling tables Ilica created
people <- read.csv("people.csv")
charges <- read.csv("charges.csv")

head(prisoners)

#Breaking existing unnamed columns into meaningful columns
people <- people %>% separate(X5, into = c("gender", "facility"), sep=1)
people <- people %>% separate(X6, into = c("sentencedate", "X7"), sep=8) 
people <- people %>% separate(X7, into = c("paroleeligible", "dob"), sep=8) 
people <- people %>% separate(dob, into = c("dob", "status"), sep=8) 
people <- people %>% separate(X0, into = c("id", "zero"), sep=7) 


#Reading date of birth, sentence data and parole eligible/release/death dates as dates.
people$dob <-  parse_datetime(people$dob)
people$paroleeligible <-  parse_datetime(people$paroleeligible)
people$sentencedate <-  parse_datetime(people$sentencedate)

#Pull universe of people convicted before sentence reform
alloldlaw <- people %>% filter(sentencedate < '1996-07-01')



#Generating dataset of people listed with R for released, which includes people who died.
released <- people %>% filter(status == "R")
#people %>% setNames(1:3, c("id", "lastname", "firstname"))
#colnames(people[1:3]) <- c("id", "lastname", "firstname")
write.csv(deaths, "Prison releases")


#Joining ODRC directory data to tables of hearing reports
hearings <- read_xlsx("Parole hearings all.xlsx")
parolehear <- people %>% right_join(hearings, by = c("id" = "OFFENDER"))
oldlaw <- parolehear %>% filter(sentencedate < '1996-07-01')
people %>% filter(sentencedate < '1996-07-01')
parolehear <- people %>% right_join(hearings, by = c("id" = "OFFENDER"))

#Generating a list of 200 random people convicted before sentencing reform who had parole hearings between 2019 and July 2022
oldlawnames <- oldlaw %>%  select(1, 3, 4, 5, 9, 19) %>% distinct()
oldlawnames <- data.table(oldlawnames)
oldlawsample <- oldlawnames[sample(.N, 200)]
write.csv(oldlawsample, "Sample of Old Law prisoners.csv")