#' Prediction of the new dataset using the trained object
#' @param train An object of class \code{\link{imageTrain}}.
#' @param data A n by 5 data.frame representing n observations in 5 dimensions.
#' @return pred The prediction array.
#' @examples
#' imagePred(train@Model, NewData)
#' imagePred(train@Model, imagePreProc (data, clusters=5, freq=TRUE,distorg=TRUE, dist=TRUE, cov=TRUE))
#' @section Warning:
#' The NewData data.frame should be processed with the exact same options as the training dataset.
#' @export
imagePred <- function(train, data){
  pred<-predict(train,subset(data, select=-c(ID,e)))
  return(pred)
}
