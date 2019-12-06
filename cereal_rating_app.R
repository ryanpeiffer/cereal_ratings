#author: Ryan Peiffer
#date: December 2019

#project: shiny app that allows users to rate cereals based on health and taste.


library(shiny)

ui <- fluidPage(

    titlePanel("The Ultimate Cereal Battle!"),

    sidebarLayout(
        sidebarPanel(
            h3("Please rate (cereal name):"),
            #TODO make this use the cereal name lol
            sliderInput("health",
                        "Health",
                        min = 1,
                        max = 10,
                        value = 5),
            
            sliderInput("taste",
                        "Taste",
                        min = 1,
                        max = 10,
                        value = 5),
            
            actionButton("submit",
                        "Submit my ratings!")
        ),

        # Show a plot of the generated distribution
        mainPanel(
           plotOutput("distPlot")
        )
    )
)


server <- function(input, output) {

    output$distPlot <- renderPlot({
        # generate bins based on input$bins from ui.R
        x    <- faithful[, 2]
        bins <- seq(min(x), max(x), length.out = input$health + 1)

        # draw the histogram with the specified number of bins
        hist(x, breaks = bins, col = 'darkgray', border = 'white')
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
