#My email: jlealriv@lcg.unam.mx


library(cluster)
suppressPackageStartupMessages(library(factoextra))
suppressPackageStartupMessages(library(dendextend))
suppressPackageStartupMessages(library(ape))


#==================================================================
```{python}
  #Lo hice en el notebook de la lcg
  
from Bio.Blast.Applications import NcbiblastpCommandline

path_file='./ABC.faa'
blastp_cline = NcbiblastpCommandline(query='./ABC.faa', subject='./ABC.faa', outfmt=7, max_hsps=1, use_sw_tback=True, evalue=100, out='target.csv')

print(blastp_cline)

stdout, stderr = blastp_cline()

#==================================================================

#Leer el archivo del blast
InputData  <- read.table("C:/Users/yoroi/OneDrive/Escritorio/BioInfo/target.csv", header = TRUE, sep = "", quote="")
#InputData




#Obtener que secuencias faltan para obtener una matriz cuadrada.
#Es probable que el filtro haya omitido secuencias y no todas las proteinas tuvieron match contra todas
miss_rows<-sapply(unique(InputData$ABC1.Q03024),FUN=function(x){
  z<-which(InputData$ABC1.Q03024==x)
  if (length(z)!=100)
    logical<-TRUE
  else logical<-FALSE
  return(logical)})

mr<-unique(InputData$ABC1.Q03024)[miss_rows]



miss_col<-sapply(unique(InputData$ABC1.Q03024.1),FUN=function(x){
  z<-which(InputData$ABC1.Q03024.1==x)
  if (length(z)!=100)
    logical<-TRUE
  else logical<-FALSE
  return(logical)})

mc<-unique(InputData$ABC1.Q03024.1)[miss_col]




#Crear un df con las columnas que nos interesan
rows<-c(InputData$ABC1.Q03024,mr)
cols<-c(InputData$ABC1.Q03024.1,mc)
BitScores<-c(InputData$X285,rep(0,length(mr)))

blast <- data.frame(row = rows,
                    col = cols,
                    BS = BitScores)


#Ignorar matches contra s� mismos
for(i in 1:10000){
  if (blast$row[i]==blast$col[i]){
    blast$BS[i] <- 0
  }
}

#Ordenar el df seg�n los nombre de las secuencias para poder hacer la diagonal de ceros
blastp <- blast[order(blast$row,blast$col),]
#blastp




#Crear la matriz
matrixBitScores <- matrix(blastp$BS,nrow=length(unique(blastp$row)),ncol=length(unique(blastp$col)),
                          byrow=T,
                          dimnames=list(unique(blastp$row),unique(blastp$col)))


#Normalizar la matriz
maximum <- sapply(1:100,FUN=function(i){
  max <- max(matrixBitScores[i,])
  return(max)})


maxBit <- rep(maximum,each=100)

NormalizedMatrix<-matrixBitScores/maxBit
DisMatrix <- 1-NormalizedMatrix
#tail(DisMatrix)




#Ver el numero de clusters por varios metodos
fviz_nbclust(DisMatrix, FUN = hcut, hc_func = "hclust", hc_method = "ward.D2", method = "silhouette", k.max = 20) +
  labs(subtitle = "Silhouette method")

#==================================================================

fviz_nbclust(DisMatrix, FUN = hcut, hc_func = "hclust", hc_method = "ward.D2", method = "wss", k.max = 20) +
  labs(subtitle = "Elbow method")

#==================================================================

fviz_nbclust(DisMatrix, FUN = hcut, hc_func = "hclust", hc_method = "ward.D2", method = "gap_stat", k.max = 20) +
  labs(subtitle = "GapStat method")




#Crear los dendogramaspor varios metodos
csin <- hclust(dist(DisMatrix, method = "euclidean"), method = "single")
#Obtener los coeficientes
sinCoef<-coef(csin)
sinCoef
#==================================================================
cave <- hclust(dist(DisMatrix, method = "euclidean"), method = "average")
aveCoef<-coef(cave)
aveCoef
#==================================================================
ccom <- hclust(dist(DisMatrix, method = "euclidean"), method = "complete")
comCoef<-coef(ccom)
comCoef
#==================================================================
cwar <- hclust(dist(DisMatrix, method = "euclidean"),method = "ward.D2")
warCoef<-coef(cwar)
warCoef


#Guardar los dendrogramas


csin_tree<-as.phylo(csin)
write.tree(phy=csin_tree, file="HClustSingle.newick")
#==================================================================
cave_tree<-as.phylo(cave)
write.tree(phy=cave_tree, file="HClustAverage.newick")
#==================================================================
ccom_tree<-as.phylo(ccom)
write.tree(phy=ccom_tree, file="HClustComplete.newick")
#==================================================================
cwar_tree<-as.phylo(cwar)
write.tree(phy=cwar_tree, file="HClustWard.newick")
#==================================================================



#Visualizar rapidamente los clusters
#set a plotting area of three horizontally contiguous panels
par(mfrow = c(1, 4))


#set a plotting area of three horizontally contiguous panels
par(mfrow = c(1, 4))


#set margins for the plotting area
par(mar = c(2, 2, 2, 1) + 0.1)


#plot the dendogram, with labels hanging down from zero
plot (csin, hang = -1, main = "Single")
rect.hclust(csin, k=4,  border=1:16)
csin4 <- cutree(csin, k=4)

plot (cave, hang = -1, main = "Average")
rect.hclust(cave, k=4,  border=1:16)
cave4 <- cutree(cave, k=4)

plot (ccom, hang = -1, main = "Complete")
rect.hclust(ccom, k=4,  border=1:16)
ccom4 <- cutree(ccom, k=4)

plot (cwar, hang = -1, main = "Ward.D")
rect.hclust(cwar, k=4,  border=1:16)
cwar4 <- cutree(cwar, k=4)




#Para visualizar de mejor manera el clustering

#set a plotting area of three horizontally contiguous panels
##par(mfrow = c(1, 4))


#set a plotting area of three horizontally contiguous panels
##par(mfrow = c(1, 4))

##fviz_cluster(list(data = DisMatrix, cluster = cwar4))

#Para visualizar de mejor manera el clustering
##fviz_cluster(list(data = DisMatrix, cluster = ccom4))

#Para visualizar de mejor manera el clustering
##fviz_cluster(list(data = DisMatrix, cluster = cave4))

#Para visualizar de mejor manera el clustering
##fviz_cluster(list(data = DisMatrix, cluster = csin4))

#Con esto se confirma que los clusters son muy parecido entre si, exceptuando el m�todo single



#==================================================================
#Build the dendogram with agnes

aClust <- agnes(DisMatrix, method = "complete")

#Obtener ACoefficient
aCoeff <- aClust$ac
aCoeff
#El coeficiente es el mismo que con HClust



#Visualizarlo
pltree(aClust, cex = 0.6, hang = -1, main = "agnes Dendrogram Complete") 

#Podemos ver que el dedograma es muy similar al que sale con hclust. Por lo que s�lo hare este en AGNES

rect.hclust(as.hclust(aClust), k=4, border=2:4)
aCls4 <- cutree(as.hclust(aClust), k = 4)


#Para visualizar de mejor manera el clustering
#fviz_cluster(list(data = DisMatrix, cluster = aCls4))


#Guardar el dedograma en formato newick
acom_tree<-as.phylo(as.hclust(aClust))
write.tree(phy=acom_tree, file="AgnesComplete.newick")



#==================================================================
#Build the dendogram with diana
#jerarquico divisivo

dClust <- diana(DisMatrix)

dCoeff <- dClust$dc
dCoeff

#Guardar el cluster
#Guardar el dedograma en formato newick
acom_tree<-as.phylo(as.hclust(dClust))
write.tree(phy=acom_tree, file="Diana.newick")



#Visualizar el cluster

pltree(dClust, cex = 0.6, hang = -1, main = "Diana Dendrogram")
rect.hclust(as.hclust(dClust), k=4, border=2:4)
dCls4 <- cutree(as.hclust(dClust), k = 4)

#fviz_cluster(list(data = DisMatrix, cluster = dCls4))



#El clustering de igual manera fue muy parecido a los m�todos anteriores





#Compare two dendograms (slow method)
#Se puede observar que est�n clusterizados de una manera muy similar, exceptuando que est�n invertidos

#dend1 <- as.dendrogram (ccom)
#dend2 <- as.dendrogram (as.hclust(aClust))

#dend_list <- dendlist(dend1, dend2)
#tanglegram(dend1, dend2, main = paste("Entanglement =", round(entanglement(dend_list))))


###Se visualizaran con otra herramienta adem�s de guiarnos por el Aglomerative Coefficient para discernir por un mejor modelo
