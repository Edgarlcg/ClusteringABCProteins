# Proyecto Clustering

*Leal Rivera José Edgar*

## Introducción

**Consideraciones para clustering**

Para el análisis y cluster, se deben de tomar en cuenta la naturaleza y cantidad de las variables.

Con esto se podrá saber qué medidas utilizar para

*Medir la similitud (en este trabajo utilizamos la medida de distancia euclidiana)

*Como definir los clusters

*Cuántos grupos aproximadamente deben formarse



Además cuando se seleccionan los atributos es muy importante normalizarlos y saber cómo hacerlo.

Por último, una vez analizada la naturaleza de los datos, y que es necesario utilizar métodos jerárquicos, se debe tomar en cuenta si se quiere minimizar o maximizar la distancia.



#### Método Jerárquico Conglomerados

**Single**

![](C:/Users/yoroi/OneDrive/Escritorio/BioInfo/ProyectoClustering/Dendogramas/HClustSingle.png)

Podemos observar que existen 4 cluster, El grupo ABC2a y ABC2b y el grupo ABC1 muy diversificado. Por otro lado, ABC3 fue el grupo que diversifico poco y hasta el último.

**Average**

![](C:/Users/yoroi/OneDrive/Escritorio/BioInfo/ProyectoClustering/Dendogramas/HClustAverage.png)

Se puede observar 4 grupos, ABC1 que se subdivide en 3 grupos, algo poco probable porque solo una secuencia se conservo después de diversificarse, cuando por azar, a este subgrupo deberían pertenecer más secuencias proteicas. El grupo ABC2a que se subdivide en dos subgrupos.

El grupo ABC3 coincide con el método Single, donde no se ha diversificado a otro subgrupo.

**Complete**

![](C:/Users/yoroi/OneDrive/Escritorio/BioInfo/ProyectoClustering/Dendogramas/HClustComplete.png)

Se pueden observar 3 cluster con las mismas características que el anterior. Solo que el grupo ABC1 se divide en 2 grandes grupo



**Ward** 

![](C:/Users/yoroi/OneDrive/Escritorio/BioInfo/ProyectoClustering/Dendogramas/HClustWard.png)

Se observan los 4 grupos muy bien clusterizados. Se aprecia mejor la organización en dos subgrupos de la familia de proteínas ABC3 y mejor agrupamiento de la familia ABC1.

#### Jerárquico Divisivo

**DIANA**

![](C:/Users/yoroi/OneDrive/Escritorio/BioInfo/ProyectoClustering/Dendogramas/Diana.png)



*DISCUSIÓN*

Los árboles obtenidos por el método Complete y Single son congruentes con la taxonomía de las proteínas, mientras que los obtenidos por los métodos Average y Ward no lo son tanto. El arbol más informativo es el Average, mientras que el menos informativo por su manera de proceder maximizando las diferencias es el Ward.

Asimismo el que más se acerca a la naturaleza, juntando más de cerca a la familia 2a y 2b son los árboles  Complete y DIANA, sin embargo, el Complete, es el único arbol que no separa a una sola proteina en un subgrupo del cluster ABC1 como los demás, un hecho poco probable.

**¿Cuál es el arbol con el Agglomerative Coefficiente más alto?**

El árbol obtenido por el método Ward con 0.90, seguido del árbol Complete con 0.66



[Código]([ClusteringABCProteins/Proyecto Clustering at main · Edgarlcg/ClusteringABCProteins (github.com)](https://github.com/Edgarlcg/ClusteringABCProteins/tree/main/Proyecto Clustering))



