#Instalando Pacman y llamando otros paquetes.
pacman::p_load(dplyr, sjmisc, car, sjlabelled, stargazer, haven)
#limpiando R
rm(list=ls())       
options(scipen=999)
#cargando la base de datos
load(url("https://github.com/Kevin-carrasco/metod1-MCS/raw/main/files/data/external_data/latinobarometro2020.RData"))
head(latinobarometro2020)
colnames(latinobarometro2020)
#Selección de variables a utilizar
find_var(data = latinobarometro2020, "Confianza")

proc_data <- latinobarometro2020 %>% select(p13st_e, p13st_d, p13st_f, p13st_g,
                                            reeduc_1, sexo, edad, idenpa)
#Comprobar la creación de la nueva base
names(proc_data)
sjlabelled::get_label(proc_data)
#Filtrar la base para solo quedar con los datos de Chile
proc_data <- proc_data %>%
  dplyr::filter(idenpa==152)

#Procesamiento de variables

 ##Descriptivo
frq(proc_data$p13st_e)
### Recodificacion
