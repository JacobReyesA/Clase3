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
proc_data <- proc_data %>% set_na(., na = c(-2, -1))
proc_data$p13st_e <- recode(proc_data$p13st_e, "1=3; 2=2; 3=1; 4=0")
proc_data$p13st_d <- recode(proc_data$p13st_d, "1=3; 2=2; 3=1; 4=0")
proc_data$p13st_f <- recode(proc_data$p13st_f, "1=3; 2=2; 3=1; 4=0")
proc_data$p13st_g <- recode(proc_data$p13st_g, "1=3; 2=2; 3=1; 4=0")
proc_data <- proc_data %>% rename("conf_gob"=p13st_e, # Confianza en el gobierno
                                  "conf_cong"=p13st_d, # Confianza en el congreso
                                  "conf_jud"=p13st_f, # Confianza en el Poder Judicial
                                  "conf_partpol"=p13st_g) # Confianza en los partidos políticos
proc_data$conf_gob <- set_label(x = proc_data$conf_gob,label = "Confianza: Gobierno")
get_label(proc_data$conf_gob) 
proc_data$conf_cong  <- set_label(x = proc_data$conf_cong, label = "Confianza: Congreso")
proc_data$conf_jud  <- set_label(x = proc_data$conf_jud, label = "Confianza: Poder judicial")
proc_data$conf_partpol  <- set_label(x = proc_data$conf_partpol, label = "Confianza: Partidos politicos")
proc_data$conf_inst <- (proc_data$conf_gob+proc_data$conf_cong+proc_data$conf_jud+proc_data$conf_partpol)
summary(proc_data$conf_inst)
get_label(proc_data$conf_inst)
proc_data$conf_inst  <- set_label(x = proc_data$conf_inst, label = "Confianza en instituciones")
frq(proc_data$conf_gob)
##Descriptivo
frq(proc_data$p13st_e)
### Recodificacion
proc_data$conf_gob <- set_labels(proc_data$conf_gob,
                                 labels=c( "Ninguna"=0,
                                           "Poca"=1,
                                           "Algo"=2,
                                           "Mucha"=3))

proc_data$conf_cong <- set_labels(proc_data$conf_cong,
                                  labels=c( "Ninguna"=0,
                                            "Poca"=1,
                                            "Algo"=2,
                                            "Mucha"=3))

proc_data$conf_jud <- set_labels(proc_data$conf_jud,
                                 labels=c( "Ninguna"=0,
                                           "Poca"=1,
                                           "Algo"=2,
                                           "Mucha"=3))

proc_data$conf_partpol <- set_labels(proc_data$conf_partpol,
                                     labels=c( "Ninguna"=0,
                                               "Poca"=1,
                                               "Algo"=2,
                                               "Mucha"=3))
frq(proc_data$conf_gob)
frq(proc_data$reeduc_1)
# recodificacion usando funcion 'recode' de la libreria car
proc_data$reeduc_1 <- car::recode(proc_data$reeduc_1, "c(1,2,3)=1; c(4,5)=2; c(6,7)=3")
proc_data$reeduc_1 <- factor(proc_data$reeduc_1,
                             labels = c("Educacion basica", "Educacion media", "Educacion superior"),
                             levels = c(1, 2, 3))
proc_data <- rename(proc_data,"educacion"=reeduc_1)
proc_data$educacion <- set_label(x = proc_data$educacion,label = "Educación")
#Variable Sexo
proc_data$sexo <- car::recode(proc_data$sexo, "1=0;2=1")
proc_data$sexo <- factor(proc_data$sexo,
                         labels=c("Hombre","Mujer"),
                         levels=c(0,1))
proc_data$sexo <- set_label(x = proc_data$sexo, label="Sexo")
frq(proc_data$sexo)
#Variable Edad
proc_data$edad <- set_label(x = proc_data$edad, label = "Edad")
get_label(proc_data$edad)
#Generacion de base de datos proesada para el analisis
proc_data <- as.data.frame(proc_data)
stargazer(proc_data, type = "text")
save(proc_data, file = "ipo/input/data-proc/latinobarometro_proc.RData")
