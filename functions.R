# fonctions carto

spdfCarr <- function(shape, size=1000) {
  require(rgeos)
  shape <- gUnaryUnion(shape)
  bb <- bbox(shape)
  cs <- c(size, size)
  cc <- bb[, 1] + (cs/2)
  cd <- ceiling(diff(t(bb))/cs)
  # je crée une Grid Topo
  gt <- GridTopology(cellcentre.offset=cc, cellsize=cs, cells.dim=cd)
  # j'extrais les coordonnées des centroides des carreaux
  gtCoord <- coordinates(gt)
  # j'extrais les ID des carreaux
  gtID <- IDvaluesGridTopology(gt)
  # je crée l'ID des carreaux à partir des coord X/Y des centroides des carreaux
  gtID <- paste0("I", ceiling(gtCoord[,1]), ceiling(gtCoord[,2]))
  # je calcule les LLC (arrondis à l'entier inf.) de chaque carreau
  gtCoordLLC <- data.frame("x"=floor(gtCoord[,1] - (cs[1]/2)),
                           "y"=floor(gtCoord[,2] - (cs[2]/2)))
  # je crée un nouvel ID des carreaux = "I+coordLLCx+coordLLCy"
  gtCoordLLCid <- data.frame("ID"=paste0("I", gtCoordLLC$x, gtCoordLLC$y))
  # je nomme les lignes de mon data frame en f de l'ID des carreaux
  row.names(gtCoordLLCid) <- IDvaluesGridTopology(gt)
  # je transforme ma Grid Topo en Spatial Polygon Grid Topo (SPGT)
  spgt <- as.SpatialPolygons.GridTopology(gt)
  # je transforme mon SPGT en Spatial Polygon Data Frame (SPDF)
  spdf <- SpatialPolygonsDataFrame(spgt, data=gtCoordLLCid)
  # je fixe les attributs de projection de mon SPDF
  # à la meme valeur que celle de mon shape d'origine
  proj4string(spdf) <- proj4string(shape)
  # je renomme les identifiants des carreaux en f de gtCoordLLCid
  spdfWithNames <- spChFIDs(obj=spdf, x=as.character(gtCoordLLCid$ID))
  # je ne retiens que les carreaux qui se superposent à mon shape d'origine
  # utilisation de la f° as.vector car un objet de classe SPDF 
  # ne supporte pas l'indexation par une matrice
  # la f° gIntersects avec argument byid=T renvoie une matrice de valeurs logiques
  spdfWithNames <- spdfWithNames[as.vector(gIntersects(spdfWithNames, shape, byid=T)), ]
  return(spdfWithNames)
}

# f pour créer un Spatial Polygon d'hexagones
SPolyHex <- function(shape, size=1000) {
  grdHexPoints <- spsample(shape, type = "hexagonal", cellsize=size)
  grdHexPol <- HexPoints2SpatialPolygons(grdHexPoints)
}