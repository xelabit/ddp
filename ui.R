library(shiny)
shinyUI(fluidPage(
        
        # Application title
        titlePanel("Word Prediction Application"),
        
        sidebarLayout(
                
                sidebarPanel(
                        p(
                                "This is a simple application which allows a user to predict a next word he or
                                she might want to enter next based on a set of words which have already been
                                entered."
                        ),
                        p(
                                "The instructions are following: start typing your text in a text field. Each
                                time you hit a space bar an algorithm will evaluate the text you have entered
                                and predict three most relevant words. Unfortunately the speed is yet a
                                subject of consideration so it might take a few seconds for an algorithm to
                                predict results."
                        ),
                        tags$a(href = "", "A link to GitHub repository")
                ),
                
                mainPanel(
                       textInput("userText", "Input your text here"),
                        p(
                                actionButton("controller1", label=verbatimTextOutput("option1")),
                                actionButton("controller2", label=verbatimTextOutput("option2")),
                                actionButton("controller3", label=verbatimTextOutput("option3")),
                                style="text-align: center;")
                )
        )
))

