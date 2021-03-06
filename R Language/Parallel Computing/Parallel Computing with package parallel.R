##
## Parallel Computing with package parallel
##
## @author:  galaa
## @web:     www.galaa.mn
## @created: 2017/06/18 22:52:30
##

## -----------------------------------------------------------------
## CPU/Цөмийн тоог тогтоох
## -----------------------------------------------------------------

the.number.of.useful.cores <- max(1, parallel::detectCores() - 1)

# Энд цөмүүдийн нэгийг бусад тооцоололд зориулан орхиж байна.
# Энэ нь угтаа зэрэгцээ тооцооллын кластерын тоог заах юм.
# Системийн санах ойн хэмжээ, түүнийг ашиглах байдлаас шалтгаалан уг тоог бууруулах шаардлага гарч болно.

## -----------------------------------------------------------------
## Зэрэгцээ тооцооллын кластер үүсгэх, хувьсагчийн утга дамжуулах
## -----------------------------------------------------------------

switch(.Platform$OS.type,
  "unix" = {
    ## Хувьсагчийн утга дамжуулах
    root <- 0.5
    # type = "FORK" төрлийн кластерийн хувьд эх хүрээнүүд дэх өмнө зарлагдсан хувьсагчдад шууд хандаж чадна.
    # Иймд хувьсагчийн утга дамжуулах зорилгоор нэмэлт үйлдэл гүйцэтгэх шаардлагагүй болно.
    ## Кластер үүсгэх, Linux/Mac үйлдлийн системүүдийн хувьд
    parallel.computing.cluster <- parallel::makeCluster(the.number.of.useful.cores, type = "FORK")
    # Кластер үүсгэсний дараа хувьсагчийн утга дамжуулах бол дор үзүүлсэн байдлаар clusterExport() функц ашиглана.
  },
  "windows" = {
    ## Кластер үүсгэх, бүх үйлдлийн системийн хувьд (Windows-ийг оролцуулан)
    parallel.computing.cluster <- parallel::makeCluster(the.number.of.useful.cores) # type = "PSOCK" буюу Parallel Socket Cluster
    ## Хувьсагчийн утга дамжуулах
    root <- 0.5
    parallel::clusterExport(parallel.computing.cluster, "root")
    # Дээрх тушаалаар кластерийн дотоод хүрээнд ижил нэртэй боловч уг хувьсагчаас тусдаа хувьсагч үүсч утга нь дамжина.
    # Тиймээс үүний дараа уг хувьсагчийн утгыг өөрчлөх нь кластер дахь хувьсагчийн утганд нөлөөгүй.
    # Харин PSOCK буюу Parallel Socket Cluster-ын хувьд эх хүрээний хувьсагчийн утга автоматаар дамжихгүй.
  }
)

## ----------------------------------------------------------------
## Зэрэгцээ тооцооллын функцүүд
## ----------------------------------------------------------------

# Зэрэгцээ тооцоолол явагдаж байгааг өөрөөр хэлбэл тооцоолуурын цөмүүд "бүгд" ашиглагдаж байгааг тодорхой харуулахын тулд харьцангуй их ачаалал өгөхүйц код бичив.
# Task Manager, System Monitor зэрэг зохих програмаар CPU ашиглалтаа харна уу. Урьдчилаад нээсэн байвал тохиромжтой.

parallel::parLapply(parallel.computing.cluster,
  1:50,
  function(x) mean(runif(n = 5e6)^root * x)
)

parallel::parSapply(parallel.computing.cluster,
  as.character(1:50),
  function(s) {
    x <- as.numeric(s)
    u <- runif(n = 5e6)^root * x
    c(mean = mean(u), sd = sd(u))
  }
)

## ----------------------------------------------------------------
## Кластер устгах
## ----------------------------------------------------------------

parallel::stopCluster(parallel.computing.cluster)
