#' Function for outputing STM dataset into json
#' 
#' @param mod stm model
#' @param data data for stm model
#' @param covariates vector of covariates you want to visualize
#' @param text name of covariate where text is held
#' @return An object of class \code{htmlwidget} that will
#'   intelligently print itself into HTML in a variety of contexts
#'   including the R console, within R Markdown documents,
#'   and within Shiny output bindings.
#' @import htmlwidgets
#'
#' @export

stmBrowser_widget <- function(
  mod, data, covariates, text, id=NULL, n=1000, labeltype="prob"
){

  x <- list()
  
  # Create widget
  htmlwidgets::createWidget(
    name = "stmBrowser",
    x = x,
    width = width,
    height = height,
    package = "stmBrowser",
    htmlwidgets::sizingPolicy(viewer.suppress = viewer.suppress)
  )
  
}

