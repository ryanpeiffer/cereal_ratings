#author: Ryan Peiffer
#date: December 2019

#project: shiny app that allows users to rate cereals based on health and taste.

#===========================================================================
# setup
#===========================================================================

#load libraries
library(shiny)

#define function for selecting a cereal
pick_cereal <- function(image_files) {
    if(length(image_files) > 0) {
        
        #pick a cereal from list of valid options
        cereal_file <- sample(image_files, 1)
        cereal_name <- substr(cereal_file, 1, nchar(cereal_file)-4)
        
        #text to rate the cereal
        text <- paste("Please rate:", cereal_name)
        
        #display a picture
        image <- TRUE
        
    } else {
        cereal_file <- NULL
        
        #text to indicate no cereals remain
        text <- "You have rated all the cereals! Thanks!"
        
        #do not display a picture
        image <- FALSE
        
    }
    
    return (list(cereal_file, text, image))
}


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


server <- function(input, output, session) {
   
     #read in list of image files
    image_files <- list.files("images/test")
    
    
    ### generate initial view of ShinyApp ###
    #pick a cereal and store respective variables with descriptive names
    vals <- pick_cereal(image_files)
    cereal_file <- unlist(vals[1])
    display_text <- unlist(vals[2])
    display_image <- unlist(vals[3])

    #generate text output for the cereal
    output$cereal_name <- renderText({image_files})

    #generate image output for the cereal
    if(display_image) {
        output$image <- renderImage({
            return(list(src = paste0("images/test/", cereal_file)))
        }, deleteFile = FALSE)
    } else {
        output$image <- NULL
    }
    ### end of initial view ###
    
    
    
    ### updates for when user clicks button ###
    observeEvent(input$submit, {
        #TODO save the user's ratings
        
        #remove current cereal from list
        image_files <- image_files[!image_files %in% cereal_file]
        
        #select a new cereal
        vals <- pick_cereal(image_files)
        cereal_file <- unlist(vals[1])
        display_text <- unlist(vals[2])
        display_image <- unlist(vals[3])
        
        
        ## UPDATE ALL DISPLAYS ##
        #text output
        output$cereal_name <- renderText({image_files})

        #generate image output for the cereal
        if(display_image) {
            output$image <- renderImage({
                return(list(src = paste0("images/test/", cereal_file)))
            }, deleteFile = FALSE)
        } else {
            output$image <- NULL
        }

        
        #TODO reset input sliders?
    })

}

# Run the application 
shinyApp(ui = ui, server = server)