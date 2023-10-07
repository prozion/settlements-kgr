#! /usr/bin/env Rscript

library(dplyr)
library(stringr)

source("regions_dict.R")

get_region_id <- function(reg_name) {
  id <- regions_dict[reg_name]
  # ifelse(is.na(id), strsplit(region_name, " ")[[1]], id)
}

get_municipality_id <- function(mun_name) {
  mun_name %>% str_split(" ") %>% sapply(first)
}

hms_str_to_double <- function(hms) {
  hms_parsed <- hms %>%
                strsplit("\\.") %>%
                lapply(as.integer) %>%
                lapply(function(v) (v[1] + (v[2]*60 + v[3]) / 3600)) %>%
                unlist
  return(hms_parsed)
}

get_syns <- function(df) {
  df %>%
  .[["settlement"]] %>%
  table %>%
  .[. > 1] %>%
  names
}

existed_ids <- readLines("~/temp/settlements_kgr/existed_ids.txt")

settlements <- read.csv("~/data/settlements_2021/data.csv")
df <- settlements %>%
      select(region, municipality, settlement, latitude, longitude, population) %>%
      filter(population >= 1000, population < 10000) %>%
      arrange(desc(population))

settlement <- str_replace_all(df$settlement, " ", "_")
settlement_r <- paste(settlement, get_region_id(df$region), sep="_")
settlement_m_r <- paste(settlement, get_municipality_id(df$municipality), get_region_id(df$region), sep="_")

ids <- c()
for (i in 1:nrow(df)) {
  id <- ifelse(settlement[i] %in% existed_ids,
              ifelse(settlement_r[i] %in% existed_ids, settlement_m_r[i], settlement_r[i]),
              settlement[i])
  existed_ids <- c(existed_ids, id)
  ids <- c(ids, id)
}

df$id <- ifelse(settlement %in% existed_ids,
            ifelse(settlement_r %in% existed_ids, settlement_m_r, settlement_r),
            settlement)

tabtree <- with(df, sprintf("%s%slat:%3.6f lon:%3.6f pop:%s region:\"%s, %s\"",
                      ids,
                      ifelse(ids != settlement, sprintf(" name:\"%s\" ", settlement), " "),
                      hms_str_to_double(latitude),
                      hms_str_to_double(longitude),
                      population,
                      municipality, region))

fp <- file("~/data/settlements_kgr/source/russia_10K_1K.tree", "w")
writeLines(tabtree, fp)
