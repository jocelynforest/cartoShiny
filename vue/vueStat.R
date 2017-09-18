vueStat = tabPanel('Carte stat', icon = icon("map"),
                   sidebarLayout(
                     sidebarPanel(width=2,
                                  selectInput('methDiscr', "Méthode de discrétisation",
                                              choices = c("fixed", "sd", "equal",
                                                          "pretty", "quantile", "kmeans",
                                                          "hclust", "bclust", "fisher",
                                                          "jenks"),
                                              selected = "kmeans"),
                                  
                                  conditionalPanel(condition = "input.methDiscr == 'fixed'",
                                                   selectInput('nbClass', 'Nb de classe',
                                                               choices = c(2:5), selected = 3),
                                                   sliderInput('bornes', 'Bornes des classes',
                                                               min = 0, max = 100,
                                                               value = c(0,100))
                                  ),
                                  
                                  tags$hr(),
                                  selectInput('palCoul', 'Palette de couleurs',
                                              choices = c('rouge-bleu', 'analyse', 'autre')),
                                  
                                  # exporter la carte
                                  checkboxInput("export", "Exporter les cartes"),
                                  conditionalPanel(condition = "input.export == true",
                                                   radioButtons('format', 'Format',
                                                                c('PNG', 'JPG', 'PDF'),
                                                                inline = TRUE),
                                                   radioButtons('orientation', 'Orientation',
                                                                c('Portrait', 'Paysage'),
                                                                inline = TRUE),
                                                   selectInput('size', 'Taille',
                                                               paste(format4_3$x_pixel,
                                                                     format4_3$y_pixel,
                                                                     sep='x'),
                                                               selected = '800x600'),
                                                   downloadButton('download', 'Download'))
                     ),
                     mainPanel(
                       plotOutput('mapStat', height = 900)
                     )
                   ))
