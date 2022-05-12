library(tidyverse)
library(scales)
library(glue)
library(plotly)
library(lubridate)
library(zoo)
library(viridis)
library(hrbrthemes)
library(dashboardthemes)
options(scipen=123)

library(shiny)
library(shinydashboard)


# DATA PERBANDINGAN KASUS 2019-2020
perbandingan_lapor <- read.csv("clean/lapor_merge.csv")
perbandingan_lapor$jenis_lapor <- as.factor(perbandingan_lapor$jenis_lapor)


#DATA PERBANDINGAN KORBAN JENIS KELAMIN
jenis_korban_bulan <- read.csv("clean/jenis_korban.csv")
jenis_korban_bulan$yearmonth <- as.yearmon(jenis_korban_bulan$yearmonth, "%Y-%m")

#DATA PPU
ppu <- read.csv("clean/ppu.csv")
ppu <- pivot_longer(data = ppu,
                    cols = c("value_pekerjaan","value_usia","value_pendidikan"),
                    names_to = "jenis_value")
ppu$pekerjaan <- as.factor(ppu$pekerjaan)
ppu$range_usia <- as.factor(ppu$range_usia)
ppu$tingkat_pendidikan <- as.factor(ppu$tingkat_pendidikan)
ppu <- ppu %>%
  rename(total = value)
ppu <- pivot_longer(data = ppu,
                    cols = c("pekerjaan","range_usia","tingkat_pendidikan"),
                    names_to = "kategori")
ppu <-  ppu%>% na.omit()
ppu = subset(ppu, select = -c(jenis_value))
ppu$terlibat <- as.factor(ppu$terlibat)
ppu$kategori <- as.factor(ppu$kategori)

#DATA PBJT
pbjt <- read.csv("clean/pbjt.csv")
pbjt_long <- pivot_longer(data = pbjt,
                          cols = c("pelaku_kekerasan","bentuk_kekerasan","jenis_kekerasan", "tempat_kejadian"),
                          names_to = "kategori")
pbjt_long <- pbjt_long %>% rename(jenis = value)
pbjt_long$total_korban_berdasarkan_pelaku <- as.numeric(pbjt_long$total_korban_berdasarkan_pelaku)
pbjt_long$jumlah_korban <- as.numeric(pbjt_long$jumlah_korban)
pbjt_long$total_korban <- as.numeric(pbjt_long$total_korban)
pbjt_long$jumlah_korban2 <- as.numeric(pbjt_long$jumlah_korban2)
pbjt_long$kategori <- as.factor(pbjt_long$kategori)
pbjt_long <- pivot_longer(data = pbjt_long,
                          cols = c("total_korban_berdasarkan_pelaku","jumlah_korban","total_korban", "jumlah_korban2"),
                          names_to = "total")
pbjt_long$jenis <- as.factor(pbjt_long$jenis)
pbjt_long$kategori <- as.factor(pbjt_long$kategori)

#DATA PENDIDIKAN
pendidikan <- read.csv("clean/pendidikan.csv")

pekerjaan <- read.csv("data/pekerjaan.csv")

usia <- read.csv("data/usia.csv")


