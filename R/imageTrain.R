#' A modified version of RF classifier
#' @param data A data.frame of the pre-processed inputs.
#' @param cparallel If \code{cparallel=TRUE}, the RCPP Random Forest Classifier runs with parallel cores.
#' @param accuracy If \code{accuracy=TRUE}, the accuracy of the classifier is shown.
#' @return Model and acc, a list in which the first element is the model object (named “Model”) and the second element is the list of accuracies across the classes (named “acc”).
#' @examples
#' imageTrain(data, cparallel=TRUE, accuracy=TRUE)
#' @seealso \url{https://cran.r-project.org/web/packages/randomForest/index.html}
#' @seealso \url{https://cran.r-project.org/web/packages/caret/index.html}
#' @seealso \url{https://cran.r-project.org/web/packages/Rborist/index.html}
#' @export
imageTrain <- function(data, cparallel=FALSE, accuracy=FALSE){
  library(dplyr)
  library(randomForest)
  library(caret)
  library(Rborist)
  library(flexclust)
  acc<-NULL
  if (cparallel){
    modF<-Rborist(subset(data, select=-c(ID,e)),as.factor(data$e))
    if (accuracy){
      acc<-1- modF$misprediction
    }
  }else{
    modF<-train(as.factor(e)~.,subset(data, select=-c(ID)), method='rf')
    if (accuracy){
      rfOutput<-as.data.frame(modF$finalModel$confusion)
      acc<-1- rfOutput[,length(rfOutput)]
    }
  }
  return(list("Model" = modF, "acc" = acc))
}

