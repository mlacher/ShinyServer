# Hello, world!
#
# This is an example function named 'hello'
# which prints 'Hello, world!'.
#
# You can learn more about package authoring with RStudio at:
#
#   http://r-pkgs.had.co.nz/
#
# Some useful keyboard shortcuts for package authoring:
#
#   Build and Reload Package:  'Ctrl + Shift + B'
#   Check Package:             'Ctrl + Shift + E'
#   Test Package:              'Ctrl + Shift + T'

##open port
library(serial)
Open_Serial <- function (COMPort){

  con <- serialConnection(name = "Arduino",
                          port = COMPort,
                          mode = "9600,n,8,1",
                          buffering = "none",
                          newline = 1,
                          translation = "cr")

  open(con)
  return(con)
}

##close port
Close_serial <- function(con){
  close(con)
}

#read/write from port
RW_Serial <- function (DEV_ADDR, CMD){
  read.serialConnection(DEV_ADDR)
  write.serialConnection(DEV_ADDR, CMD)
  stopTime <- Sys.time() + 5
  while(Sys.time() < stopTime)
  {
    data<-read.serialConnection(DEV_ADDR)
    if(nchar(data)>0){
      send <- as.numeric(data)
      break
    }
    else{
      send <- 0
    }
  }
  return(send)
}
#read from port
R_Serial <- function (DEV_ADDR, Delay){
Raw_data <- ""
stopTime <- Sys.time() + Delay
  while(Sys.time() < stopTime)
  {
  newText <- read.serialConnection(DEV_ADDR)
    if(0 < nchar(newText))
    {
    Raw_data <- paste(Raw_data, newText)
    }
  }
 return(Raw_data)
}



#Meas_Data
Meas_Data<- function(RawFile){
  RawFile<- na.omit(as.numeric(unlist(strsplit(RawFile, "[\n;]"))))
  Breaths<-RawFile[seq(1, length(RawFile), 6)]
  Time<-RawFile[seq(2, length(RawFile), 6)]
  Flow<-RawFile[seq(3, length(RawFile), 6)]
  Pressure<-RawFile[seq(4, length(RawFile), 6)]
  RotSpeed<-RawFile[seq(5, length(RawFile), 6)]
  Error<-RawFile[seq(6, length(RawFile), 6)]
  Values<- cbind.data.frame(Time,Flow,Pressure,RotSpeed,Error)
  return(Values)
}
