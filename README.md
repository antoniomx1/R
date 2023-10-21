Scripts en R para Analistas de Datos


En este espacio, presento varios scripts desarrollados en R que me han sido útiles en mis actividades cotidianas como Analista de Datos.

* ExtraccionAulas.R:
Objetivo: Extraer información de bases de datos en MySQL utilizando R.
Proceso:
Conexión individual a 10 esquemas de base de datos.
Extracción de datos de cada esquema.
Almacenamiento temporal de la información en memoria.
Consolidación final en un dataframe que integra las 10 extracciones.
Librerías Principales Utilizadas:
RMySQL: Para conexión y extracción de datos desde MySQL.
tidyverse: Para la limpieza y manipulación de los datos.
Recursos Adicionales:
Se utilizan archivos complementarios donde se almacenan variables con los datos de conexión y las consultas SQL a ejecutar.


