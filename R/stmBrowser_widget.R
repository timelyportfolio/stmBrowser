#' Create an htmlwidget view of STM
#' 
#' @param mod stm model
#' @param data data for stm model
#' @param covariates vector of covariates you want to visualize
#' @param text name of covariate where text is held
#' @return An object of class \code{htmlwidget} that will
#'   intelligently print itself into HTML in a variety of contexts
#'   including the R console, within R Markdown documents,
#'   and within Shiny output bindings.
#'   
#' @examples
#' \dontrun{
#' library(stm)
#' data(poliblog5k)
#' #Create date
#' dec312007 <- as.numeric(as.Date("2007-12-31"))
#' poliblog5k.meta$date <- as.Date(dec312007+poliblog5k.meta$day,
#'                                origin="1970-01-01")
#' out <- prepDocuments(poliblog5k.docs, poliblog5k.voc, poliblog5k.meta)
#' stm.out <- stm(out$documents, out$vocab, K=50,
#'               prevalence=~rating + date,
#'               data=out$meta, init.type="Spectral",
#'               max.em.its=10) #generally run models longer than this. 
#' library(stmBrowser)
#' stmBrowser_widget(stm.out, data=out$meta, c("rating", "date"),
#'           text="text")
#' }
#' 
#' @import htmlwidgets
#'
#' @export

stmBrowser_widget <- function(
  mod, data, covariates, text, id=NULL, n=1000, labeltype="prob",
  width = NULL, height = NULL
){
  
  #Error checking:
  if(nrow(data)!=nrow(mod$theta)){
    stop("Data has a different number of rows than the STM output",call. = FALSE)
  }
  if(class(covariates)!="character"){
    stop("Please pass the names of the covariates as character strings.", call. = FALSE)
  }

  n <- min(nrow(data), n)
  message(paste("Sampling", n, "documents for visualization."))
  samp <- sample(1:nrow(data), n)
  #Write out doc level stuff
  theta <- mod$theta[samp,]
  data <- data[samp,]
  
  data_out <- lapply(
    1:nrow(data)
    ,function(i){
      doc <- list()
      
      if(!is.null(id)) doc$id <- gsub("\\.", "\\-", data[,id][i])
      if(is.null(id)) doc$id <- i
      
      doc$body <- data[,text][i]
      for(j in 1:length(covariates)){
        if(is.factor(data[,covariates[j]])) {
          data[,covariates[j]]<-
            as.character(data[,covariates[j]])
        }
        if("POSIXt"%in%class(data[,covariates[j]])){
          dateout <- jsonlite::toJSON(data[,covariates[j]],
                                      POSIXt="ISO8601")
          data[,covariates[j]] <- jsonlite::fromJSON(dateout)
        }
        if(class(data[,covariates[j]])=="Date"){
          dateout <- jsonlite::toJSON(data[,covariates[j]],
                                      Date="ISO8601")
          data[,covariates[j]] <- jsonlite::fromJSON(dateout)
        }
      }
      for(j in 1:length(covariates)){
        doc[covariates[j]] <- data[,covariates[j]][i]
      }
      for(j in 1:ncol(theta)){
        doc[paste("Topic", j)] <- theta[i,j]
      }
      
      return(doc)
    }
  )
  
  
  topics <- labelTopics(mod, n=3)[[labeltype]]
  topics <- lapply(
    1:nrow(topics)
    ,function(i){
      list(
        name = paste("Topic", i)
        ,list = paste(topics[i,], collapse=", ")
      )
    }
  )
  
  
  
  x <- list(
    options = NULL
    ,data = list(
      data = data_out
      ,topics = topics
    )
  )
  
  # Create widget
  htmlwidgets::createWidget(
    name = "stmBrowser",
    x = x,
    width = width,
    height = height,
    package = "stmBrowser"
  )
  
}

