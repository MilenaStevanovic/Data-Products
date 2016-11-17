library(shiny)
shinyUI(navbarPage("Tooth Growth",
                   tabPanel("Application",
                            titlePanel("Effect of Supplement Type on Tooth Growth"),
                            sidebarLayout(
                                sidebarPanel(
                                    radioButtons("dose", "Consider all doses or specific one?",
                                                 c("All doses" = "D",
                                                   "Dose 0.5" = "A",
                                                   "Dose 1.0" = "B",
                                                   "Dose 2.0" = "C"),
                                                 selected="D"),
                                    h5("Notes:"),
#                                     textOutput("test1"),
#                                     textOutput("test2"),
#                                     textOutput("test3"),
                                    uiOutput("test")
                                ),
                                mainPanel(
                                    h3("Boxplot"),
                                    plotOutput("plot", width = "80%", height = "300px"),
                                    h3("Result of t.test"),
                                    tableOutput("result"),
                                    textOutput("text")
                                )
                            )),
                   tabPanel("Documentation",
                            uiOutput("documentation"))
))