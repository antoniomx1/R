# Scripts en R para Analistas de Datos

En este espacio, presento varios scripts desarrollados en R que me han sido útiles en mis actividades cotidianas como Analista de Datos.

## ExtraccionAulas.R
**Objetivo:** Extraer información de bases de datos en MySQL utilizando R.

### Proceso:
1. Conexión individual a 10 esquemas de base de datos.
2. Extracción de datos de cada esquema.
3. Almacenamiento temporal de la información en memoria.
4. Consolidación final en un dataframe que integra las 10 extracciones.

### Librerías Principales Utilizadas:
- **RMySQL:** Para conexión y extracción de datos desde MySQL.
- **tidyverse:** Para la limpieza y manipulación de los datos.

### Recursos Adicionales:
Se utilizan archivos complementarios donde se almacenan variables con los datos de conexión y las consultas SQL a ejecutar.

## distribucionequipos.R
**Objetivo:** Lograr una distribución equitativa de equipos a partir de grupos con aproximadamente 70 alumnos.

### Proceso:
1. **Carga de Datos:** Iniciamos cargando la información relacionada con alumno-grupo. Posteriormente, cargamos archivos para identificar diferentes segmentaciones y aplicar filtros sobre ciertas asignaturas.
2. **Definición de Segmentaciones:** Una vez que tenemos los datos, definimos las segmentaciones (Mx, LATAM). A continuación, realizamos conteos para determinar el número total de grupos.
3. **Generación de Equipos:** Basándonos en el conteo, formamos equipos que representen aproximadamente el 10% de cada grupo.
4. **Exportar resultados:** Finalmente, exportamos la información en un archivo CSV. Adicionalmente, mediante un bucle, generamos una impresión detallada de cada grupo-equipo por docente.

### Librerías Principales Utilizadas:
- tidyverse
- readxl
- googlesheets4
- googledrive

### Recursos Adicionales:
Utilizamos varios catálogos que nos ayudan a identificar el tipo de alumno, la materia que cursa y su estatus actual.

