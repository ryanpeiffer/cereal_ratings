#author: Ryan Peiffer
#date: December 2019

#project: shiny app that allows users to rate cereals based on health and taste.

#===========================================================================
# setup
#===========================================================================

#load libraries
library(shiny)

#user inputs
image_folder <- "images/test"



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
            h3(textOutput("output_text")),
            imageOutput("image"),
            textOutput("files_left")
        )
    )
)


server <- function(input, output, session) {
   
     #read in list of image files
    image_files <- reactiveVal(list.files(image_folder))
    
    #pick a new cereal whenever the submit button is pressed
    cereal_file <- eventReactive(input$submit, {
        cereal <- ""
        if(length(image_files()) > 0) {
            cereal <- sample(image_files(), 1)
        }
        
        #remove the chosen cereal from list so we cant pick it again
        image_files(image_files()[!image_files() %in% cereal])
        
        return(cereal)
    }, ignoreNULL = FALSE) #ignoreNULL = false allows it to pick one upon startup

    
    #generate text output
    output$output_text <- renderText({
        cereal_name <- substr(cereal_file(), 1, nchar(cereal_file()) - 4)
        paste("Please rate:", cereal_name)
    })
    #TODO when out of cereals, display "You have rated all of the cereals. Thanks!"

    
    #generate image output
    output$image <- renderImage({
        return(list(src = paste(image_folder, cereal_file(), sep = '/')))
    }, deleteFile = FALSE)
    #TODO make the error not show when we reach the end
    

    #list of files for debugging
    output$files_left <- renderText({
        paste(image_files())
    })

}

# Run the application 
shinyApp(ui = ui, server = server)