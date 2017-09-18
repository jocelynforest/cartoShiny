---
title: "Todo list"
output: html_document
---

### Interface

- améliorer le rendu global

### Fonctionnalités

- Script de lancement de l'appli
- Gestion des données SIG de type JSON
- Ajouter des variables aux données SIG chargées par l'utilisateur, par création ou merge avec une table de données annexe
- Actualiser un selectInput inclus dans un conditionalPanel. **Nécessaire pour créer un selectInput des variables dispo dans les données attributaires des données SIG importées par l'utilisateur**
- Créer des cartes carroyées
- Fonctions de lissage
- Permettre à l'utilisateur de télécharger la doc utilisateur (si possible en plusieurs formats)
- Packager l'appli
- Compiler la doc d'un fichier Rmd en md dynamiquement (sans avoir besoin d'éditer manuellement le fichier md)
- Démasquer des onglets 
    + avec une combinaison de touches : voir javascript event (gros travail pour pas grand chose) ;
    + avec le *package* shinyjs : risque sur la fiabilité/maintenance du package ;
    + à l'aide d'un input (solution la + simple et à envisager).
- Inclure des fichiers en html avec includeHTML (pour l'instant, freeze les onglets suivants)
- Gérer l'export en mode portrait / paysage
