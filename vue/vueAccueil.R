# Onglet d'accueil de l'application

labAccueil = "Accueil"
labIcon = "home"

imInsee = 'logoInsee396x81.PNG'
mdInstruction = './ressource/markdown/instructions.md'
refAnnuaire = "http://lannuaire.service-public.fr/navigation/accueil_sl.html"
labRefAnnuaire =  "Annuaire de l'administration - Base de données locales" 


vueAccueil = tabPanel(labAccueil, icon = icon(labIcon),
         br(),
         img(src = imInsee, 
             # centrer l'image
             # style="display: block; margin-left: auto; margin-right: auto;",
             width=396, height=81),
         #"Bienvenue sur l'application cartoShiny",
         includeMarkdown(mdInstruction),
         img(src = 'dataGouvFr1.PNG', width = 150, height = 50),
         br(),
         tags$a(href = refAnnuaire, labRefAnnuaire)
)
         
#Vue Accueil à simplifier ...