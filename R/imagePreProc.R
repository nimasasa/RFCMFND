#' Defining new variables, running the KCCA
#' @param data A n by 5 data.frame representing n observations in 5 dimensions.
#' @param clusters An Integer value for the number of clusters. The default value is 0.
#' @param freq If \code{freq=TRUE}, the frequency column is added to the current input dataset.
#' @param distorg If \code{distorg=TRUE}, the distance to origin column is added to the current input dataset.
#' @param dist If \code{dist=TRUE}, the distance among points for each study is added to the current input dataset.
#' @param cov If \code{cov=TRUE}, the covariances (XY, XZ, YZ) columns are added to the current input dataset.
#' @return dfg A data.frame of the pre-processed inputs.
#' @examples
#' imagePreProc (data, clusters=5, freq=TRUE,distorg=TRUE, dist=TRUE, cov=TRUE)
#' @seealso \url{https://cran.r-project.org/web/packages/flexclust/index.html}
#' @export
imagePreProc <- function(data, clusters=0, freq=TRUE,
                         distorg=TRUE, dist=TRUE, cov=TRUE){
  library(dplyr)
  library(caret)
  library(flexclust)
  fr<-NULL
  dis<-NULL
  disor<-NULL
  covar<-NULL
  df<-as.data.frame(data)
  colnames(df)<- c('ID','x','y','z','e')
  dfK<-as.data.frame(scale(df[c(-1,-5)]))
  dff<-df
  df$disor<-sqrt(df$x^2+df$y^2+df$z^2)
  dff[c(-1,-5)]<-dfK
  y<-group_by(dff,ID)
  yy<-group_by(df,ID)

  if (clusters!=0){
    fit.km <- kcca(dfK, k=clusters, kccaFamily("kmeans"))
    cl<-NULL
    for (id in unique(df$ID)) {
      studies <- subset(dff, ID == id)
      cl<-rbind(cl,as.vector(table(factor(as.vector(predict(fit.km,
                                                            newdata=cbind(studies$x,studies$y,studies$z))),lev=1:5))))
    }

    cl<-as.data.frame(cl)
    clust<-1:clusters
    colnames(cl)<-c(paste('cl', clust, sep=''))
    dfg<-summarise(yy,e=first(e))
    dfg<-as.data.frame(cbind(dfg,cl))

  } else {
    df_new <- df %>%
      mutate(xnew = ifelse(is.na(x), -1, floor(x)),
             ynew = ifelse(is.na(y), -1, floor(y)),
             znew = ifelse(is.na(z), -1, floor(z))) %>%
      mutate(xnew = factor(xnew, levels = 0:100),
             ynew = factor(ynew, levels = 0:100),
             znew = factor(znew, levels = 0:100)) %>%
      as.data.frame


    df_new <- cbind(select(df_new),
                    model.matrix(~ ID + xnew + ynew + znew + e, data = df_new) %>% as.data.frame %>%
                      dplyr:::select(-1))
    dfg <- aggregate (df_new, by=list(df_new$ID), max )

    dfg <- dfg[-1]
    #dfg<-dfg[colSums(dfg)!=0]
  }
  if (freq){
    fr <- df %>%
      group_by(., ID) %>%
      summarise(., fr=n())
    fr<-as.data.frame(fr)

  }
  if (distorg){
    disor <- summarise(yy, mean_dist = mean(disor, na.rm = TRUE),
                       sd_dist = sd(disor, na.rm = TRUE))
    disor[is.na(disor)] = 0
    disor<-as.data.frame(disor)

  }
  if (cov){
    covar <- summarise(yy, cov_xy = cov(x, y),
                       cov_xz = cov(x, z),
                       cov_yz = cov(y, z))
    covar[is.na(covar)] = 0
    covar<-as.data.frame(covar)

  }
  if (dist){
    dist_func = function(x){
      return(sum(sum(dist(x))))
    }
    dis <- summarise(yy, ID_dist=dist_func(cbind(x, y, z)))
    dis[is.na(dis)] = 0
    dis<-as.data.frame(dis)

  }
  dfg$fr<-fr$fr
  dfg$meandisor<-disor$mean_dist
  dfg$sdisor<-disor$sd_dist
  dfg$dis<-dis$ID_dist
  dfg$covxy<-covar$cov_xy
  dfg$covxz<-covar$cov_xz
  dfg$covyz<-covar$cov_yz
  return (dfg)
}
