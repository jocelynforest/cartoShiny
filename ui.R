# path : /media/gilles/7871-5411/r/shinyApps/maps_v2
# author : Gilles FIDANI
# creation : 2015
# update : 2016-11-10
# encoding : utf-8
# depends : markdown, shiny, shinyBS, tmap

library(shiny)
library(shinyBS)
library(DT)

source('formatsExport.R', local = TRUE)
source('./vue/vueAccueil.R', local = TRUE)
source('./vue/vueData.R', local = TRUE)
source('./vue/vueCarte.R', local = TRUE)
source('./vue/vueStat.R', local = TRUE)
source('./vue/vueContact.R', local = TRUE)
source('./vue/vuePropos.R', local = TRUE)
source('./vue/vueDev.R', local = TRUE)
source('./vue/vueQuitter.R', local = TRUE)


 #source('palettesInsee.R', localTRUE = TRUE)

navbarPage("CartoShiny", 
  id="navbar", inverse = TRUE,
           
   # onglet accueil 
  vueAccueil,
  # onglet données tabulées
  vueData,
  #onglet choix carte
  vueCarte,
  # onglet carte stat
  vueStat,
  # onglet contacts
  vueContact,
  # onglet à propos
  vuePropos,
  # en option ... vueDev
  vueDev,
  # onglet quitter
  vueQuitter
)
