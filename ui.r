

## UI for app
shinyUI(fluidPage
        (


 titlePanel("Visualisations for identifiable non-residential buildings in OSM V GEODIRECTORY" ),           

  #input
 sidebarPanel(  helpText(br("Choose from the selection of Nace Codes to see the different completeness rates"),
            br("ALL NACE CODES"),   
             br("G: WHOLESALE AND RETAIL TRADE;REPAIR OF MOTOR VEHICLES AND MOTORCYCLES"),
             br("S: OTHER SERVICE ACTIVITIES"),
             br("O: PUBLIC ADMINISTRATION AND DEFENCE;COMPULSORY SOCIAL SECURITY"),
             br("I: ACCOMMODATION AND FOOD SERVICE ACTIVITIES"),
             br("Q: HUMAN HEALTH AND SOCIAL WORK ACTIVITIES"),
             br("P: Education")))

  	,			

    ## <embed percentages heat map here 
 mainPanel(

    div(tabsetPanel(


  tabPanel("Percentage Completeness", 
                  tags$embed(src="http://www.openheatmap.com/view.html?map=NeuroglandularPredetainCounterblasts", 
                             height = 750,width= 1000)
                 ),
  tabPanel("Charts",
              h4("Display line charts, box plot, scatter plot, bubble charts, histogram, density plot for the compared variables"),    
          selectInput("OSM",label = "Choose an OpenStreetMap (OSM) variable to compare",
                          choices= c(
                            "OSM_ALL",                  
                            "OSM_S",
                            "OSM_G",                  
                            "OSM_O",                  
                            "OSM_P",                  
                            "OSM_I",                  
                            "OSM_Q"
                          ),selected = "OSM_ALL"),    
              selectInput("GEODIR",label = "Choose a Geodirectory (GEODIR) variable to compare",
                          choices= c(
                            "GEODIR_ALL",
                            "GEODIR_S",
                            "GEODIR_G",
                            "GEODIR_O",
                            "GEDOIR_P",                  
                            "GEODIR_I",                  
                            "GEODIR_Q"),selected = "GEODIR_ALL"),
             htmlOutput("linech"),
               htmlOutput("barch"),
               htmlOutput("scatterch"),
               htmlOutput("histch"),
               htmlOutput("density"),
               sliderInput("binsx",
                          "Number of bins for OSM:",
                          min = 0,
                          max = 50,
                          value = 30),
               sliderInput("binsy",
                          "Number of bins for GEODIR:",
                          min = 100,
                          max = 200,
                          value = 100),
              plotOutput("distPlot"), height = "900px", width = "1500px"
              ), 
      tabPanel("Markers",h4("Marker representation of Percentage Completeness"), 
               selectInput("char1", "", choices =levels(counties_rows$variable)),
                htmlOutput("googleVismerged"),
                htmlOutput("bubblech"), width = "1500px", height = "900px"
                ),
 navbarMenu("OSM Users",
      tabPanel("Building Locations",h4("check building locations, names and types"), 
               tags$embed(src="http://www.openheatmap.com/view.html?map=CodomesticationGanglandsOutlaughs", height = 750,width= 1500), 
               helpText("Log on to Openstreetmap to make updates"),
               a(href="http://www.openstreetmap.org/search?query=Republic%20of%20Ireland#map=7/53.138/-7.530", "Click Here!")),
      tabPanel("Nominatim",tags$embed(src="http://nominatim.openstreetmap.org/search.php?q=ireland&viewbox=-140.63%2C53.23%2C140.63%2C-53.23",
                                      height = 750,width= 1500)
      ),
      tabPanel("Then & Now",tags$embed(src="https://mvexel.github.io/thenandnow/#7/53.755/-6.899",height = 750,width= 1500)
      )),
      
tabPanel("Data Analytics",h4("Check out some analytical visualisations on the data"),
              selectInput("dens1", "",
                          choices =levels(out$Category)[0:7]),
              selectInput("dens2", "",
                          choices =levels(out$Category)[8:14]),
              h3(textOutput("caption")),
              htmlOutput("density"))
      
  
  ), class = "span120"))
))

  
