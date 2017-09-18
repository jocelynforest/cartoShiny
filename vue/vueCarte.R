labCarte = 'Fonds de carte'
labIcon = 'map'




vueCarte =   tabPanel(labCarte, icon = icon(labIcon),
           
           # SidebarLayout
           sidebarLayout(
             sidebarPanel(width=2,
                          
                          # import données SIG
                          fileInput('dataSIG', 'Choisir les shapefile',
                                    multiple=TRUE),
                          
                          actionButton("tabBut", icon = icon("table"),
                                       "Table attributaire"),
                          
                          bsModal("tabAttr", "Table", "tabBut", size = "large",
                                  tableOutput("tableAttrib")),
                          
                          tags$hr(),
                          
                          tags$h3("Variables de jointure"),
                          
                          # choix variable jointure données TAB
                          selectInput('varJointTAB', 'Données TAB',
                                      choices = ""),
                          
                          # choix variable jointure données SIG
                          selectInput('varJointSIG', 'Données SIG',
                                      choices = ""),
                          
                          # # bouton de jointure
                          # actionButton('jointBut', icon = icon('gear'),
                          #              'Joindre données SIG+TAB'),
                          
                          # variable d'intérêt à représenter graphiquement
                          selectInput('varInt', 'Variable d\'intérêt',
                                      choices = ""),
                          
                          # type de représentation
                          selectInput('repStat', 'Type de représentation :',
                                      c('', 'Choroplethe', 'Ronds', 'Bilocalisée'),
                                      selected = ''),
                          
                          # DISCRETISATION
                          tags$hr()
             ),
             
             mainPanel(
               plotOutput('map')
             )
           )) ## FIN ONGLET FONDS DE CARTE