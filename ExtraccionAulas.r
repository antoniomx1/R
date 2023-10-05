library(RMySQL)
library(DBI)
library(dplyr)
library(MultiLEDS)
library(readxl)
library(tidyverse)



source("D://Users/jvelazhe/Desktop/R/IDcategoryn23.R")

source("D://Users/jvelazhe/Desktop/R/Consultas_MySQLn.R")

#### Reporte Completo#####
cons <- dbListConnections(MySQL())
for(con in cons)dbDisconnect(con)

cruces= c('completo[,5] <- as.numeric(as.character(completo[,5]))
completo[,13] <- as.numeric(as.character(completo[,13]))
completo$calificacion[is.na(completo$calificacion)]<- 0
modalida[,4] <- as.numeric(as.character(modalida[,4]))
modalida <- dplyr::select(modalida,matricula,clave,modalidad)
modalida <- tidyr::unite(modalida,"Con",c(matricula,clave),sep="_")
completo$matr <- completo$matricula
completo$clav <- completo$clave
completo <- tidyr::unite(completo,"Con",c(matr,clav),sep="_")
completo <- dplyr::left_join(completo,modalida,by="Con")
completo$modalidad[is.na(completo$modalidad)]<-"Sin Modalidad"')

reporte_completo <- NULL  # Inicializa la variable fuera del bucle


try({for (i in 1:10) {
  conetsion <- paste("c",i,sep="")
  conetsion <- get(conetsion)
  idcat <- paste("ID_Category",i,sep = "")
  idcat <- eval(parse(text = idcat))
  conexion <- paste(a,conetsion,sep="")
  conexion <- eval(parse(text = conexion))
  reportecompleto=paste(queryallLic1,idcat,queryallLic2,idcat,sep=" ")
  completo<- dbGetQuery(conexion,statement=reportecompleto)
  modeva1<-paste(ModEva,idcat,sep=" ")
  modalida<- dbGetQuery(conexion,statement=modeva1)
  cruz <- paste("cruces",i,sep = "")
  cruz <- eval(parse(text = cruces))
  aula <- ifelse(i < 10,paste("Aula","0",i,sep=""),paste("Aula",i,sep=""))
  completo$aula <- aula

  if(i==1) reporte_completo <- completo else reporte_completo <- rbind(reporte_completo,completo)
  cons <- dbListConnections(MySQL())
  for(con in cons)dbDisconnect(con)
}
})