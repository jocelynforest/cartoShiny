---
title: "Documentation"
output: html_document
---

### Les données SIG

- Mapinfo : fichiers TAB, DAT, ID, MAP -> codage binaire
- Mapinfo : fichier MIF, MID : format d'échange ou d'export Mapinfo. MID contient les données attributaire, MIF la structure de la table et la géométrie -> codage texte
- ESRI : fichiers SHP, SHX, DBF, parfois SBN, SBX et PROJ -> codage binaire
- Geo ou TopoJSON : format JavaScript Object Notation
- KML : Keyhole Markup Language (Google) -> codage texte

### Importation des données

La gestion des importations est complexifiée par la possibilité d'avoir à traiter des données multiples (shapefile, mapinfo) ou des données uniques (json, kml). Pour les données uniques, aucun problème. Par contre, les données multiples obligent à recourir à une phase intermédiaire de renommage des fichiers. En effet Shiny identifie les fichiers importés par numérotation séquentielle, selon l'ordre de séléction des fichiers. Pour faire cohabiter les 2 méthodes de traitement (une sans renommage, l'autre avec)

### Export des cartes

Les valeurs des tailles d'export (formatExport.R sourcé en en-tête de ui.R) sont exprimées en pixel. Pour passer des pixels aux pouces (*inches*), il faut diviser les pixels par le nombre de ppp (point par pouce, ou *dpi : dots per inch*). Par défaut, on considère ici la valeur de 75 dpi (valeur proposée en affichage par la plupart des écrans de PC). Il serait possible, mais non pertinent de mon point de vue, de proposer à l'utilisateur de sélectionner le nombre de dpi (par une liste déroulante par ex). Pour plus de détails sur les ppp/dpi, voir [https://fr.wikipedia.org/wiki/Point_par_pouce](https://fr.wikipedia.org/wiki/Point_par_pouce)

La fonction pdf, utilisée pour initialiser un device en pdf, attend comme valeur d'argument `width` et `height` des données en pouces. Il faut donc diviser la valeur des reactives expressions `exportSizeX` et `exportSizeY` par 75.

### La gestion dynamique des onglets

Lorsqu'un utilisateur active le checkboxInput `repStat`, il faut créer un onglet supplémentaire pour effectuer le paramétrage des données à représenter. C'est utile car il faut de nombreux widgets pour paramétrer la méthode de discrétisation. Pour réaliser des onglets dynamiques, voir les fonctions `renderUI` coté server et `uiOutput` coté ui. Le *package* `shinyJS` permet également de réaliser ces opérations.

### Le *package* shinyBS

Utilisé pour faire apparaitre des fenêtres *modales*, cad qui captent le focus et affichent des informations diverses. Approfondir son utilisation, sans pour autant trop investir (risque maintenance/pérennité).

### Généralités

On source le code nécessaire à l'application en précisant l'argument `local=TRUE` afin de ne pas sourcer le code dans l'environnement global (qui y resterait une fois l'application fermée).

### Diverse

#### Insérer un boutton quitter sur la navbarPage
Il faut donner un identifiant à la navbar (par ex. `navbarPage(id="navbar")`), insérer un tabPanel contenant une valeur (ex `tabPanel("tite", value="stop"`), et placer dans `server.R` un observer (`observe({if(input$navbar == "stop") stopApp()})`).

#### La fonction `readOGR`

Argument `dsn` doit se terminer sans / sous Windows (pas sous Linux, qui accepte avec et sans).
