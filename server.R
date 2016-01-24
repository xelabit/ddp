library(shiny)
dfList <- list()
for (i in 1:4) {
        dfList[[i]] <- readRDS(paste("~/R/DS/Capstone/app/tm_data", i, ".rds",
                                     sep = ""))
}
## 's' is a string containing words a user have entered
library(stringr)
backoff <- function(s){
        ## k is the number of words left to predict
        result <- NULL 
        predictionWord <- NULL
        k <- 3
        s <- str_trim(s, side = "both")
        s <- tolower(s)
        words <- strsplit(s, " ")[[1]]
        n <- length(words)
        if (n > 3) n = 3
        while (n >= 0) {
                if (n == 0) f <- "" else f <- " "
                beginning <- paste(tail(words, n = n), collapse = " ")
                tok <- dfList[[n + 1]][grep(paste("^", beginning, f,
                                                  sep = ""),
                                            dfList[[n + 1]]$tm_labels), ]
                
                if (dim(tok)[1] > 3 & k == 3) {
                        predictionWord <- head(tok, n = 3)[[1]]
                        k <- 0
                        predictionWord <- sapply(predictionWord, function(x) tail(strsplit(x, " ")[[1]], n = 1))
                        for (i in 1:length(predictionWord)) {
                                result[i] <- predictionWord[[i]]
                        }
                        predictionWord <- result
                }
                else if (dim(tok)[1] > 0) {
                        predictionWord <- c(predictionWord, tok[[1]])
                        predictionWord <- sapply(predictionWord, function(x) tail(strsplit(x, " ")[[1]], n = 1))
                        for (i in 1:length(predictionWord)) {
                                result[i] <- predictionWord[[i]]
                        }
                        predictionWord <- unique(result)
                        if (length(predictionWord) > 3) predictionWord <- predictionWord[1:3]
                        k <- 3 - length(predictionWord)
                }
                if (k == 0) n <- -1
                n <- n - 1
        }
        predictionWord        
}
shinyServer(
        function(input, output, session) {
                    
                output$option1 <- renderPrint({
                        if(input$userText %in% c("", " ")){backoff("")[1]}  
                        
                        else if (substr(input$userText, nchar(input$userText), nchar(input$userText)) == " "){
                                backoff(input$userText)[1]
                        }           
                })
                output$option2 <- renderPrint({
                        if(input$userText %in% c("", " ")){backoff("")[2]}  
        
                        else if (substr(input$userText, nchar(input$userText), nchar(input$userText)) == " "){
                                backoff(input$userText)[2]
                        }           
                })
                output$option3 <- renderPrint({
                        if(input$userText %in% c("", " ")){backoff("")[3]}  
        
                        else if (substr(input$userText, nchar(input$userText), nchar(input$userText)) == " "){
                                backoff(input$userText)[3]
                        }           
                })
                observeEvent(input$controller1, {
                        if(input$userText %in% c("", " ")){x <- backoff("")[1]}    ## to stay consistent
                        ## in case the user clicks.
                        else if (substr(input$userText, nchar(input$userText), nchar(input$userText)) == " "){
                                x <- backoff(input$userText)[1]
                        } 
                        
                        updateTextInput(session, "userText", value = paste0(input$userText, x, " "))
                })
                observeEvent(input$controller2, {
                        if(input$userText %in% c("", " ")){x <- backoff("")[2]}    
                        else if (substr(input$userText, nchar(input$userText), nchar(input$userText)) == " "){
                                x <- backoff(input$userText)[2]
                        } 
                        
                        updateTextInput(session, "userText", value = paste0(input$userText, x, " "))
                })
                observeEvent(input$controller3, {
                        if(input$userText %in% c("", " ")){x <- backoff("")[3]}    
                        else if (substr(input$userText, nchar(input$userText), nchar(input$userText)) == " "){
                                x <- backoff(input$userText)[3]
                        } 
                        
                        updateTextInput(session, "userText", value = paste0(input$userText, x, " "))
                })
        }
)