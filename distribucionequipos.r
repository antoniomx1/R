library(tidyverse)
library(readxl)
library(googlesheets4)
library(googledrive)
gs4_auth("jvelazhe@utel.edu.mx")



linksaulasdocentes <- read_excel("//Tut-095/REPORTES/FRONT/linksaulasdocentes.xlsx")
Sabana <- read.csv("//Tut-095/REPORTES/FRONT/sabana.csv", header = TRUE, sep = ",",fileEncoding =   "LATIN1") 
reportecompleto <- read.csv("G://Mi unidad/Reports/reporte_completo_Lic.csv", header = TRUE, sep = ",",fileEncoding =   "LATIN1") %>% 
  left_join(linksaulasdocentes,by = "aula") %>% 
  mutate(materia =  sub(".*_", "", clave)) %>%  unite("clavem",c(matricula,grupo,materia),sep = "_") %>% select(clavem,id,materia_id,link,correo) %>% 
  mutate(linkperfilalumno=paste(link,id,"&course=",materia_id))

alianza <- read.csv("//Tut-095/REPORTES/ESTADOS/alianzamodalida.csv",header = TRUE,sep = ",",encoding="latin1",stringsAsFactors = FALSE)
alianza <- mutate(alianza,Matricula = as.numeric(as.character(gsub(".*?([0-9]+).*", "\\1",alianza$Matr)))) %>% 
  select(Matricula,Alianza) %>% rename(matricula = Matricula)
reglanegocios <- read.csv("//Tut-095/REPORTES/ESTADOS/reglas_negocios.csv",header = TRUE,sep = ",",encoding="latin1",stringsAsFactors = FALSE)
reglanegocios <- rename(reglanegocios,matricula = MATRICULA)

# 
# predistribucion  <- Sabana %>% left_join(reglanegocios,by = "matricula") %>% 
#   filter(edo_moodle == "Activo",
#          inicio_plus == 2808,grepl("L1C101|L1C128|L1C113|L1DSE101|L1MK101|L1CM101|L1CPA101|L1CC101|L2DE101",clave_materia),!grepl("Ejecutivos",Regla_Negocio)) %>% 
#   mutate(Tipo= if_else(grepl("Latam",Regla_Negocio),"Latam","Mx"),orden=if_else(Tipo == "Latam",1,2)) %>%
#   group_by(idprof,clave_materia,grupo,orden) %>% arrange(orden) %>% 
#   mutate(conteo = row_number(),alumnos=n()) %>%  
#   select(matricula,nombre,email,idprof,profesor,email_profesor,clave_materia,grupo,asignatura,conteo,alumnos,Tipo,orden) %>%
#   mutate(alumnosequipo= floor(alumnos*.10),equipo= ceiling((conteo*10)/alumnos)) %>% 
#   unite("clavem",c(matricula,grupo,clave_materia),sep = "_",remove = F) %>% 
#   left_join(reportecompleto,by = "clavem") %>%ungroup(.) %>% 
#   select(matricula,nombre,email,grupo,asignatura,equipo,linkperfilalumno,idprof,profesor,email_profesor) %>% 
#   rename(Mat_Docente=idprof,Docente=profesor) %>% arrange(grupo,equipo)


predistribuciont  <- Sabana %>% left_join(reglanegocios,by = "matricula") %>% 
  filter(edo_moodle == "Activo",
         inicio_plus == 910,grepl("L1C101|L1C128|L1CC101|L1CM101|L1PD101|L1PS101|L2DE101",clave_materia),!grepl("Ejecutivos",Regla_Negocio)) %>% 
  mutate(Tipo= if_else(grepl("Latam",Regla_Negocio),"Latam","Mx"),orden=if_else(Tipo == "Latam",1,2)) %>%
  group_by(idprof,clave_materia,grupo) %>% 
  mutate(conteo = row_number(),alumnitos=n()) %>% 
  unite("clavem",c(matricula,grupo,clave_materia),sep = "_",remove = F) %>% ungroup(.) %>% 
  select(clavem,alumnitos)




predistribucion  <- Sabana %>% left_join(reglanegocios,by = "matricula") %>% 
  filter(edo_moodle == "Activo",
         inicio_plus == 910,grepl("L1C101|L1C128|L1CC101|L1CM101|L1PD101|L1PS101|L2DE101",clave_materia),!grepl("Ejecutivos",Regla_Negocio)) %>% 
  mutate(Tipo= if_else(grepl("Latam",Regla_Negocio),"Latam","Mx"),orden=if_else(Tipo == "Latam",1,2)) %>%
  group_by(idprof,clave_materia,grupo,orden) %>% arrange(orden) %>% 
  mutate(conteo = row_number(),alumnos=n()) %>%  
  select(matricula,nombre,apellidos,email,grupo,clave_materia,asignatura,profesor,email_profesor,Aula,conteo,alumnos,Tipo,orden) %>%
  unite("clavem",c(matricula,grupo,clave_materia),sep = "_",remove = F) %>% 
  left_join(predistribuciont,by = "clavem")
  
alumnos20<- predistribucion %>% filter(alumnitos <=20 )%>% 
  mutate(alumnosequipo= floor(alumnos*.02),equipo= ceiling((conteo*2)/alumnos)) %>% 
  left_join(reportecompleto,by = "clavem") %>% ungroup(.) %>% mutate(equipos=paste("Equipo",equipo,sep = "_"),
                                                                     grupos=paste(grupo,equipos,sep = " "))  


alumnos40<- predistribucion %>% filter(alumnitos >20 & alumnitos <=45 )%>% 
    mutate(alumnosequipo= floor(alumnos*.05),equipo= ceiling((conteo*5)/alumnos)) %>% 
    left_join(reportecompleto,by = "clavem") %>% ungroup(.) %>% mutate(equipos=paste("Equipo",equipo,sep = "_"),
                                                                       grupos=paste(grupo,equipos,sep = " "))
  
  alumnos80 <- predistribucion %>% filter(alumnitos > 45) %>% 
  mutate(alumnosequipo= floor(alumnos*.10),equipo= ceiling((conteo*10)/alumnos)) %>% 
  left_join(reportecompleto,by = "clavem") %>% ungroup(.) %>% mutate(equipos=paste("Equipo",equipo,sep = "_"),
                                                                     grupos=paste(grupo,equipos,sep = " "))

  
distribucion <- rbind(alumnos40,alumnos80,alumnos20)    

alumnos <-  distribucion %>% 
  select(matricula,nombre,apellidos,correo,grupos,clave_materia,asignatura,Aula)

opacad <-googlesheets4::read_sheet(ss="1WHf6HBAFOuvV3-keg3zQNLtqBDTDtdW0lL2yo-zVkiM",range="K1:M5000",col_types = "ccc") %>% 
  rename(idprof = `Matricula de profesor`,nombre=`Nombre titular`,apellidos=`Apellidos titular`) %>%  
  mutate(idprof=as.numeric(idprof)) %>% 
  filter(!is.na(idprof),!duplicated(idprof)) 

docientes <-  distribucion %>% 
  select(idprof,email_profesor,grupos,clave_materia,asignatura,Aula) %>% group_by(idprof,grupos) %>% 
  filter(!duplicated(idprof)) %>% left_join(opacad,by = "idprof") %>% 
  select(idprof,nombre,apellidos,email_profesor,grupos,clave_materia,asignatura,Aula) %>% ungroup(.)

columnasalumnos <- names(alumnos)
names(docientes) <- columnasalumnos


predistribution <- rbind(alumnos,docientes)



write.csv(predistribution,"//Tut-095/REPORTES/FRONT/distribucion.csv",row.names = F)

