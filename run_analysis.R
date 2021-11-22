## PACKAGES REQUIRED

library(dplyr)

## DOWNLOAD THE DATA SET

nombreArch <- "getdata_projectfiles_UCI HAR Dataset.zip"

## Checks if the archive already exists
if(!file.exists(nombreArch)) {
    archURL <- " https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2
    FUCI%20HAR%20Dataset.zip"
    download.file(archURL, nombreArch, method = "curl")
}

## Check if the folder exists
if (!file.exists("UCI HAR Dataset")) {
    unzip(nombreArch)
}

## ASSIGNING ALL DATA FRAMES

caracteristicas <- read.table("UCI HAR Dataset/features.txt", col.names = 
                                  c("n", "functions"))
actividades <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = 
                              c("code", "activity"))
sujetos_Prueba <- read.table("UCI HAR Dataset/test/subject_test.txt", 
                              col.names = "subject")
prueba_x <- read.table("UCI HAR Dataset/test/x_test.txt", col.names = 
                           caracteristicas$functions)
prueba_y <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "code")
sujeto_entrenamiento <- read.table("UCI HAR Dataset/train/subject_train.txt", 
                                   col.names = "subject")
entrenamiento_x <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = 
                                  caracteristicas$functions)
entrenamiento_y <- read.table("UCI HAR Dataset/train/Y_train.txt", 
                              col.names = "code")

## MERGES THE TRAINING AND THE TEST SETS TO CREATE ONE DATA SET

X <- rbind(entrenamiento_x, prueba_x)
Y <- rbind(entrenamiento_y, prueba_y)
Sujeto <- rbind(sujeto_entrenamiento, sujetos_Prueba)
datos_fusionados <- cbind(Sujeto, Y, X)

## EXRACTS ONLY THE MEASUREMENTS ON THE MEAN AND STANDAR DEVIATION FOR EACH 
## MEASUREMENT

DatosOrdenados <- datos_fusionados %>% select(subject, code, contains("mean"), 
                                              contains("std"))

## USES DESCRIPTIVE ACTIVITY NAMES TO NAME THE ACTIVITIES UN THE DATA SET

DatosOrdenados$code <- actividades[DatosOrdenados$code, 2]

## APPROPIATELY LABELS THE DATA SET WITH DESCRIPTIVE VARIABLE NAMES

names(DatosOrdenados)[2] = "actividad"
names(DatosOrdenados) <- gsub("Acc", "Aceler?metro", names(DatosOrdenados))
names(DatosOrdenados) <- gsub("Gyro", "Gir?scopo", names(DatosOrdenados))
names(DatosOrdenados) <- gsub("BodyBody", "Cuerpo", names(DatosOrdenados))
names(DatosOrdenados) <- gsub("Mag", "Magnitud", names(DatosOrdenados))
names(DatosOrdenados) <- gsub("^t", "Tiempo", names(DatosOrdenados))
names(DatosOrdenados) <- gsub("^f", "Frecuencia", names(DatosOrdenados))
names(DatosOrdenados) <- gsub("tBody", "TiempoCuerpo", names(DatosOrdenados))
names(DatosOrdenados) <- gsub("-mean()", "Media", names(DatosOrdenados),
                              ignore.case = T)
names(DatosOrdenados) <- gsub("-std()", "STD", names(DatosOrdenados),
                              ignore.case = T)
names(DatosOrdenados) <- gsub("-freq()", "Frecuencia", names(DatosOrdenados),
                              ignore.case = T)
names(DatosOrdenados) <- gsub("angle", "Angulo", names(DatosOrdenados))
names(DatosOrdenados) <- gsub("gravity", "Gravedad", names(DatosOrdenados))

## CREATES A SECOND, INDEPENDENT TIDY DATA SET WITH THE AVERAGE OF EACH 
## VARIABLE FOR EACH ACTIVITY AND EACH SUBJECT

datosFinales <- DatosOrdenados %>% 
    group_by(subject, actividad) %>%
    summarise_all(funs(mean))
write.table(datosFinales, "DatosFinales.txt", row.names = F)

str(datosFinales)

datosFinales 