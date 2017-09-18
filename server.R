# path : /media/gilles/7871-5411/r/shinyApps/maps_v2
# author : Gilles FIDANI
# creation : 2015
# update : 2016-11-28
# encoding : utf-8

library(rgdal)
library(tmap)
library(tools) # pour la fonction file_path_sans_ext
library(shinyBS)
library(classInt)
library(DT)

# sourcer le dico de données
dd <- read.csv2("dataDic")

# sourcer les fonctions carto
source("functions.R", local = TRUE)
source('palettesInsee.R', local = TRUE)

function(input, output, session) {
  
  options(shiny.maxRequestSize = 100*1024^2)
  
  # BOUTON EXIT
  observe({
    if(input$navbar == "stop") stopApp()
  })
  
  # Données attributaires SIG en fenêtre modale
  output$tableAttrib <- renderTable({
    req(dataSIG())
    data.frame("Nom"=names(dataSIG()@data),
               "Type"=sapply(dataSIG()@data, typeof),
               "Exemple"=t(dataSIG()@data[1,]),
               row.names = NULL)
  })
  
  # Données tabulées (TAB)
  dataTAB <- reactive({
    inFile <- input$file1
    
    if (is.null(inFile))
      return(NULL)
    
    # recoder avec une tryCatchExpression et uun message de refus en cas de non visibilite
    read.csv(inFile$datapath, header = input$header,
             sep = input$sep, quote = input$quote, encoding = "latin1")#input$encoding)
  })
  
  # ATTENTION : risque de crash à cause de l'encodage des fichiers IO
  # Affichage des données TAB
  output$contents <- renderDataTable({
    dataTAB()
  })

  # Expression réactive pour les noms de variables des données TAB
  joint1 <- reactive({
    req(dataTAB())
    names(dataTAB())
  })
  
  # Expression réactive pour les noms de variables des données SIG
  joint2 <- reactive({
    req(dataSIG())
    names(dataSIG()@data)
  })
  
  # Actualisation de la liste des variables des données TAB
  observe({
    updateSelectInput(session, "varJointTAB", 
                      choices = c("", joint1()), selected = "")
  })
  
  # Actualisation de la liste des variables des données SIG
  observe({
    updateSelectInput(session, "varJointSIG", 
                      choices = c("", joint2()), selected = "")
  })
  
  # Actualisation de la variable des données d'intérêt
  observe({
    updateSelectInput(session, "varInt", 
                      choices = c("", joint1()), selected = "")
  })

  # # BOUTON DONNEES ATTRIBUTAIRES DANS UNE FENETRE MODALE
  # observeEvent(input$tabBut, {
  #   showModal(modalDialog(
  #     title = "Important message",
  #     "This is an important message!",
  #     easyClose = TRUE)
  #     )
  # })
  
  # INFO SUR LA SESSION CLIENT
  cdata <- session$clientData
  
  # VALUES FROM CDATA RETURNED AS TEXT
  output$clientdataText <- renderText({
    cnames <- names(cdata)
    
    allvalues <- lapply(cnames, function(name) {
      paste(name, cdata[[name]], sep=" = ")
    })
    paste(allvalues, collapse = "\n")
  })
  
  # IMPORTATION DES DONNEES SIG 
  dataSIG <- reactive({
    dataInput <- input$dataSIG
    if(is.null(dataInput)) return(NULL)
    
    # création variable dir. Celle-ci contient le nom du répertoire 
    # accueillant les fichiers SIG importés par l'utilisateur
    # myshape[1,4] car on retient la 1ere obs (au hasard) de la 4e col (datapath)
    dir <- dirname(dataInput[1,4])
    
    # je renomme les fichiers uploadés dans le rép. temp par leur vrai nom
    for(i in 1:nrow(dataInput)) {
      file.rename(from = dataInput[i, 4], 
                  to = paste0(dir, "/", tolower(dataInput[i, 1])))
      }
    
    # je liste tous les fichiers de dir
    # je sélectionne celui qui contient le pattern .shp ou .map
    # utilisation de la variable lay pour extraire le nom du fichier sans l'extension
      myFiles <- list.files(dir)
      lay <- basename(unique(file_path_sans_ext(myFiles)))
      shape <- readOGR(dsn = dir, 
                       layer = lay, 
                       stringsAsFactors = FALSE)
  })
  
  # FONCTION POUR CARTES CHORO
  
  # NUM COLONNE DE LA VARIABLE D'INTERET DES DONNEES TAB
  numColVarIntDataTab <- reactive({
    as.numeric(which(names(dataTAB()) == input$varInt),
               arr.ind = TRUE)
  })
  
  # NUM COLONNE DE LA VARIABLE D'INTERET DES DONNEES SIG
  numColVarIntDataSig <- reactive({
    as.numeric(which(names(dataSIG()) == input$varJointSIG),
               arr.ind = TRUE)
  })
  
  # UPDATE DU SLIDERINPUT POUR LES MIN ET MAX DES BORNES
  
  minVarInt <- reactive({
    req(dataTAB())
    as.numeric(min(dataTAB()[, numColVarIntDataTab()]))
  })
  
  maxVarInt <- reactive({
    req(dataTAB())
    as.numeric(max(dataTAB()[, numColVarIntDataTab()]))
  })
  # 
  # observe({
  #   updateSliderInput(session, "bornes", 
  #                     value = c(minVarInt(), maxVarInt()))
  # })

  # GESTION DES PALETTES
  

  # NB CLASSE
  nbClass <- reactive({
    as.numeric(input$nbClass)
  })
  
  # BORNES CLASSES
  # renvoi une liste
  bornesClass <- reactive({
    print(input$nbClass)
    req(dataTAB(), input$nbClass, input$methDiscr, numColVarIntDataTab())
    classIntervals(var=as.numeric(dataTAB()[, numColVarIntDataTab()]),
                   n=as.numeric(input$nbClass),
                   style=input$methDiscr,
                   rtimes=1000)
  })

  # INTERVALLES DES CLASSES DE LA VARIABLE D'INTERET
  intervClassVarInt <- reactive({
    req(bornesClass())
    tmp1 <- as.numeric(dataTAB()[, numColVarIntDataTab()])
    findInterval(tmp1,
                 bornesClass()$brks,
                 rightmost.closed = TRUE)
  })
  
  # COULEURS CLASSES DES DONNEES SPATIALES
  # renvoi un vecteur
  coulClassDataSig <- reactive({
    req(dataTAB(),
        dataSIG(),
        intervClassVarInt()
        )
    tmp1 <- intervClassVarInt()
    op1_pos[tmp1]
  })
  
  # FONCTION POUR TRACER LE FONDS DE CARTE
  map <- reactive({
    req(dataSIG())
    plot(dataSIG())
  })
  
  # FONCTION POUR TRACER LES CARTES STAT
  mapStat <- reactive({
    req(dataSIG(), 
        dataTAB(),
        coulClassDataSig()
        )
    plot(dataSIG(),
         col=coulClassDataSig(),
         axes=TRUE, 
         main="")
    legend(x="right",
           legend=bornesClass()$brks,
           fill = op1_pos[seq_len(as.numeric(input$nbClass)+1)],
           border = NA, # bordure des blocs de couleur
           bty = "n",       # boite autour de la legende
           cex = .6)
  })
  
  # FONCTION POUR EXPORTER LES CARTES CARTOGRAPHY
  # ATTENTION : mapToDownloadTmap() dans le downloadHandler
  mapToDownloadTmap <- function(){
    req(dataSIG())
    plot(dataSIG(), 
         col=coulClassDataSig(),
         axes=TRUE, 
         main="")
    legend(x="right",
           legend=bornesClass()$brks,
           fill = op1_pos[seq_len(as.numeric(input$nbClass))],
           border = NA, # bordure des blocs de couleur
           bty = "n",       # boite autour de la legende
           cex = .6)
  }


  # GESTION DE LA TAILLE D'EXPORT DES CARTES
  exportSizeX <- reactive({
    as.numeric(unlist(strsplit(input$size, "x"))[1])
  })
  
  exportSizeY <- reactive({
    as.numeric(unlist(strsplit(input$size, "x"))[2])
  })
  
  # GESTION DU DWL DES CARTES
  output$download <- downloadHandler(
    filename = function() {
      paste0("map", format(Sys.time(), "%Y-%m-%d-%X"), sep='.', 
             switch(input$format,
                    PDF='pdf',
                    PNG='png',
                    JPG='jpg')
      )
    },
    content = function(file) {
      switch(input$format,
             PDF={
               pdf(file = file,
                   width = exportSizeX()/75,
                   height = exportSizeY()/75)
               print(mapToDownloadTmap())
               dev.off()},
             PNG={
               png(filename = file, 
                   width = exportSizeX(),
                   height = exportSizeY())
               print(mapToDownloadTmap())
               dev.off()},
             JPG={
               jpeg(filename = file, 
                    width = exportSizeX(),
                    height = exportSizeY())
               print(mapToDownloadTmap())
               dev.off()}
      )
    }
  )
  
  # ONGLETS

  # onglet fonds carto
  output$map <- renderPlot({
    req(dataSIG())
    map()
  })
  
  # onglet carte stat
  output$mapStat <- renderPlot({
    req(dataSIG())
    mapStat()
  })
  
  # onglet carte carroyée
  output$mapCar <- renderPlot({
    req(dataSIG())
    if(input$typeCarr == 'Carrés') {
      plot(spdfCarr(dataSIG(), size = input$nCar))
    } else plot(SPolyHex(dataSIG(), size = input$nCar))
  })
  
  # onglet dictionnaire de données
  output$datadictionary <- renderTable({
    data.frame(dd)
  })
  
  # onglet version
  output$version <- renderText({
    as.character("Version 0.01")
  })
  
  # onglet contacts
  output$contacts <- renderUI({
    list(
      h3('Personnes à contacter'),
      a('gilles.fidani@insee.fr', href='mailto:gilles.fidani@insee.fr')
    )
  })
  
  # onglet debug
  output$debug <- renderText({
    req(dataTAB(), dataSIG(), numClassDataSig())
    # out <- capture.output(str(numClassDataSig()))
    # paste(out, collapse = "\n")
    numClassDataSig()
  })
  
  # onglet debug 1
  output$debug1 <- renderTable({
    req(dataTAB(), input$varInt, nbClass(), input$methDiscr)
    data.frame(bornesClass()$brks)
  })
  
  # onglet debug 2
  output$debug2 <- renderTable({
    req(dataTAB(),
        dataSIG(),
        input$nbClass, 
        input$methDiscr, 
        numColVarIntDataTab(), 
        numClassDataSig(),
        bornesClass()
    )
    data.frame(numColVarIntDataSig())
  })
}
