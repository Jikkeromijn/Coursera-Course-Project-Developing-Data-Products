library(shiny)
library(DT)
library(ggplot2)

mydata <- read.table("./data/recognition.txt", header = TRUE)
mydata$Recognitionmax<- as.numeric(mydata$Recognitionmax)
mydata$GRPmax<- as.numeric(mydata$GRPmax)
GRPlevels <- c(100, 500, 900, 1200)

shinyServer(
        function(input, output) {
                
                # Generate a data table based on selections made
                output$table <- DT::renderDataTable(DT::datatable({
                        mydata <- mydata
                        if (input$Category != "All") {
                                mydata <- mydata[mydata$Category == input$Category,]
                        }
                        if (input$Spotlength != "All") {
                                mydata <- mydata[mydata$Spotlength == input$Spotlength,]
                        }
                        
                        mydata
                }))
                
                # Generate a prediction function reactive to the selections made
                output$prediction <- renderPrint({
                        mydata2 <- mydata
                        if (input$Category != "All") {
                                mydata2 <- mydata2[mydata2$Category == input$Category,]
                        }
                        if (input$Spotlength != "All") {
                                mydata2 <- mydata2[mydata2$Spotlength == input$Spotlength,]
                        } 
                        
                        fit <- lm(mydata2$Recognitionmax ~ mydata2$GRPmax, data=mydata2)
                        ExpectedRecognition <- (coef(fit)[1] + coef(fit)[2]*GRPlevels)
                        ExpectedRecognition <- sprintf("%.0f%%", ExpectedRecognition)
                        Expected <- data.frame(GRPlevels, ExpectedRecognition)
                        Expected
                        
                })        
                
                # Generate a graphic representation of the database with the selections made        
                output$plot <- renderPlot({
                        mydata <- mydata
                        if (input$Category != "All") {
                                mydata <- mydata[mydata$Category == input$Category,]
                        }
                        if (input$Spotlength != "All") {
                                mydata <- mydata[mydata$Spotlength == input$Spotlength,]
                        }
                        
                        ggplot(mydata, aes(GRPmax, Recognitionmax)) + 
                        geom_point(aes(color=Spotlength)) + 
                        geom_smooth(method="glm") 
                })
                
})