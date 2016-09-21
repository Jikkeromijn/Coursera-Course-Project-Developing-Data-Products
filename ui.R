library(shiny)
library(DT)
library(ggplot2)

mydata <- read.table("./data/recognition.txt", header = TRUE)
mydata$Recognitionmax<- as.numeric(mydata$Recognitionmax)
mydata$GRPmax<- as.numeric(mydata$GRPmax)
GRPlevels <- c(100, 500, 900, 1200)

shinyUI(
        fluidPage(
                titlePanel("Database of TV ads and predicted Ad Recognition"),
                
                fluidRow(
                        
                        column(5, wellPanel(
                               selectInput("Category",
                                           "Product category:",
                                           c("All",
                                             unique(as.character(mydata$Category))))
                                )
                        ),
                        column(5, wellPanel(
                               selectInput("Spotlength",
                                           "Spotlength (seconds):",
                                           c("All",
                                             unique(as.character(mydata$Spotlength))))
                                )
                        )
                        
                ),
                fluidRow(
                        
                        column(5, wellPanel(
                        DT::dataTableOutput("table")
                                )
                        ),
                        
                        column(5, wellPanel(
                        plotOutput("plot")
                                )
                        )
                ),
                
                hr(),
                fluidRow(
                        
                        column(10, wellPanel(
                        h4('Your selection results in following predicted Ad Recognition at various GRP levels:'),
                        verbatimTextOutput("prediction")
                                )
                        )
                ),
                fluidRow(
                        
                        column(10, wellPanel(
                        h5('Explanatory notes: This tool could be used by media planners in the advertising industry. A GRP
                           is a measure of how much exposure is given to a tv ad and is calculated based on the percentage of                            the target audience reached times the average number of times a target audience person sees the ad                            . It is therefore logical that the higher the number of GRP, the higher the percentage of the                                audience that recognises the ad. Ad Recognition is a measure of potential effectiveness. For media
                           planners it is important to estimate the potential effectiveness of an ad at different GRP
                           levels. Product category and Spotlength are two important factors in the impact a tv ad may
                           have. The data in this tool are real, but totally mixed up for confidentiality and security 
                           reasons.')
                                )
                        )
                        
                )        
                )
        )