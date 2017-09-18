#onglet d'import du CSV

labData = 'Data'
labIcon = 'gear'

inputFile1 = fileInput(inputId = 'file1', 
                      label = "choisir le fichier", 
                      accept = c('text/csv','text/comma-separated-values','text/tab-separated-values','text/plain','.csv','.tsv')
                      )
inputcheckBoxHeader = checkboxInput(inputId = 'header', 
                                    label = 'En-tête', 
                                    value = TRUE
                      )
radioButtonSep = radioButtons(inputId = 'sep', 
                              label = 'Separateur',
                              choices = c("Virgule" = ',', "Point-Virgule" = ";", "Tabulation" = "\t"),
                              selected = ","
                  )

radioButtonQuote = radioButtons(inputId = 'quote',
                                label = 'Quote',
                                choices = c("Sans quote" ='', 'Double Quote'='"',  'Single Quote'="'"),
                                selected = '"')
inputSelectEncoding = selectInput(inputId = 'encoding', 
                                  label = 'Encodage', 
                                  choices = c('UTF-8', 'Latin1'),
                                  selected = 'UTF-8')
                             

vueData = tabPanel(labData, icon = icon(labIcon),
                   sidebarLayout(
                     sidebarPanel(width=2,
                                  inputFile1,
                                  tags$hr(),
                                  inputcheckBoxHeader,
                                  radioButtonSep,
                                  radioButtonQuote,
                                  inputSelectEncoding,
                                  tags$hr()
                     ),
                     mainPanel(
                       dataTableOutput('contents')
                     )
                   )
)