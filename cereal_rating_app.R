#author: Ryan Peiffer
#date: December 2019

#project: shiny app that allows users to rate cereals based on health and taste.

#===========================================================================
# setup
#===========================================================================

#load libraries
library(shiny)


#read in image filenames
image_files <- list.files("images")


#===========================================================================
# shiny app
#===========================================================================

ui <- fluidPage(

    titlePanel("The Ultimate Cereal Battle!"),

    sidebarLayout(
        sidebarPanel(
            
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
                        "Submit my rating!")
        ),

        mainPanel(
            h3(textOutput("cereal_name")),
            imageOutput("image")
        )
    )
)


server <- function(input, output) {
    #pick a cereal!
    cereal_file <- sample(image_files, 1)
    cereal_name <- substr(cereal_file, 1, nchar(cereal_file)-4)
    output$cereal_name <- renderText({
        paste("Please rate:", cereal_name)
    })
    
    #display photo of cereal box
    output$image <- renderImage({
        return(list(
            src = paste0("images/", cereal_file)
        ))
        
    }, deleteFile = FALSE)
    
}

# Run the application 
shinyApp(ui = ui, server = server)