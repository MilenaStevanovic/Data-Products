library(shiny)
shinyServer(function(input, output) {
        data(ToothGrowth)
        colnames(ToothGrowth) <- c("Length", "Supplement", "Dose")
        ToothGrowth$Dose <- as.factor(ToothGrowth$Dose)
        
#         output$test1 <- renderText("* For comparing tooth growth by supplement, we use test which compares supplement OJ and VC.")
#         output$test2 <- renderText("Null hypothesis says there is no difference in tooth growth.")
#         output$test3 <- renderText("Alternative hypothesis says there is difference in tooth growth.")
        
        output$test <- renderUI(HTML("<ul><li>For comparing tooth growth by supplement, we use test which compares supplement OJ and VC.</li>
                                          <li>Null hypothesis says there is no difference in tooth growth.</li>
                                          <li>Alternative hypothesis says there is difference in tooth growth.</li>
                                      </ul>"))
        
        plot <- reactive ({
            library("ggplot2")
            data <- switch(input$dose,
                   "D" = ToothGrowth,
                   "A" = ToothGrowth[ToothGrowth$Dose==0.5,],
                   "B" = ToothGrowth[ToothGrowth$Dose==1,],
                   "C" = ToothGrowth[ToothGrowth$Dose==2,],
                   ToothGrowth)
            ggplot(data, aes(x=Supplement, y=Length)) +
                geom_boxplot(aes(color = Supplement)) +
                labs(title="Effect of supplement type on tooth growth")
        })
        output$plot <- renderPlot(plot())
        
        result <- reactive ({
            data <- switch(input$dose,
                           "D" = ToothGrowth,
                           "A" = ToothGrowth[ToothGrowth$Dose==0.5,],
                           "B" = ToothGrowth[ToothGrowth$Dose==1,],
                           "C" = ToothGrowth[ToothGrowth$Dose==2,],
                           ToothGrowth)
            test <- t.test(Length ~ Supplement, data)
            result <- matrix (nrow = 1, ncol = 5)
            colnames(result)<-c("p_value","CI_Lower","CI_Upper", "OJ_mean", "VC_mean")
            result[1,] <- c(test$p.value, test$conf.int[1], test$conf.int[2], test$estimate[1], test$estimate[2])
            result
        })
        output$result <- renderTable(result())
        
        text <- reactive ({
            switch(input$dose,
                           "D" = "We should fail to reject null hypothesis. It is uncertain whether there will be a greater effect from either OJ or VC.",
                           "A" = "We should reject null hypotheses and accept alternative hypotheses. Supplement OJ leads to increased tooth growth comparing to supplement VC when dose is 0.5.",
                           "B" = "We should reject null hypotheses and accept alternative hypotheses. Supplement OJ leads to increased tooth growth comparing to supplement VC when dose is 1.0.",
                           "C" = "We should fail to reject null hypothesis. It is uncertain whether there will be a greater effect from either OJ or VC when dose is 2.0.",
                           "We should fail to reject null hypothesis. It is uncertain whether there will be a greater effect from either OJ or VC.")
        })
        output$text <- renderText(text())
        
        output$documentation <- renderUI(HTML("<ul><li>This is a simple application to assist you in analyzing ToothGrowth dataset.</li>
                                                   <li>It helps you determine effect of supplement type of vitamin C on tooth growth in guinea pigs.</li>
                                                   <li>Each animal received one of three dose levels of vitamin C (0.5, 1, and 2 mg/day) by one of two supplement types (OJ or VC).</li>
                                                   <li>You should select if you want to consider all dose levels or specific one.</li>
                                                   <li>Boxplot will be rendered for comparing tooth length for both supplement OJ and supplement VC, considering selected dose level.</li>
                                                   <li>T.test will be performed for comparing tooth growth by supplement, considering selected dose level.</li>
                                                   <li>Based on the test result we will conclude if supplement type has effect on tooth growth.</li>
                                              </ul>"))
})