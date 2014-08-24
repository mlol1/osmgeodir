#based on code from https://gist.github.com/dgrapov/5792778 ; shiny tutorials http://shiny.rstudio.com/tutorial/ ;
#http://cran.r-project.org/web/packages/googleVis/vignettes/googleVis_examples.htm and
#http://spark.rstudio.com/heres/EAHU/



library(shiny)


library(googleVis)
library(ggvis)
library(RColorBrewer)
library(reldist)
library(reshape)
library(sp)



counties <- read.csv("http://cs1.ucc.ie/~mlol1/CS6500/data/Percentage_Completeness.csv")
counties$X<-NULL
counties<-as.data.frame(counties)

Counties_numbers<-read.csv("http://cs1.ucc.ie/~mlol1/CS6500/Counties_numbers.csv")
Counties_numbers$X<-NULL
tab <- Counties_numbers

counties_rows<- read.csv("http://cs1.ucc.ie/~mlol1/CS6500/data/Percentage_completeness_rows.csv")
counties_rows$X<-NULL
counties_rows<-cbind(as.character(counties_rows$County), as.numeric(counties_rows$percent*100), as.character(counties_rows$variable))
counties_rows<-data.frame(counties_rows)
names(counties_rows)<-c("County","percent","variable")
counties_rows$percent<-as.numeric(counties_rows$percent)


counties_rows_numbers<-read.csv("http://cs1.ucc.ie/~mlol1/CS6500/Counties_numbers.csv")
counties_rows_numbers$X<-NULL

out<-read.csv("http://cs1.ucc.ie/~mlol1/CS6500/data/Counties_numbers_density_plot.csv")



source("helpers.R")


shinyServer(function(input, output){
#  output$spplot <- renderPlot({
    
 #   args <- switch(input$var, 
  #                 "Percent Complete: ALL NACE CODES" = list((counties$ALL_PERCENT)*100 ,"darkgreen","% Complete: ALL NACE CODES"),
  #                 "Percent Complete: G WHOLESALE AND RETAIL TRADE;REPAIR OF MOTOR VEHICLES AND MOTORCYCLES" = list((counties$NACECODE_G_PERCENT)*100,"black"," % Complete: G"),
   #                "Percent Complete: S OTHER SERVICE ACTIVITIES" = list((counties$NACECODE_S_PERCENT)*100,"darkorange","Complete: S"),
    #               "Percent Complete: O PUBLIC ADMINISTRATION AND DEFENCE;COMPULSORY SOCIAL SECURITY" = list((counties$NACECODE_O_PERCENT)*100,"darkblue","% Complete: O"),
     #              "Percent Complete: I ACCOMMODATION AND FOOD SERVICE ACTIVITIES" = list((counties$NACECODE_I_PERCENT)*100,"red","% Complete: I"),
       #            "Percent Complete: Q HUMAN HEALTH AND SOCIAL WORK ACTIVITIES" = list((counties$NACECODE_Q_PERCENT)*100,"brown","% Complete: Q"),
      #             "Percent Complete: P Education" = list((counties$NACECODE_P_PERCENT)*100,"violet","% Complete: P"))
    
  #  args$min <- input$range[1]
   # args$max <- input$range[2]
    
    #do.call(percent_spplot, args)
  #})
  output$googleVismerged = renderGvis({

    df=counties_rows[counties_rows$variable==input$char1,]
    bar=gvisBarChart(df[order(df$percent),],
                     "County","percent",
                     options=list(height=1000, width=1000,
                                  fontSize=12,legend="none"))
    geochart=gvisGeoChart(counties_rows[(counties_rows$variable)==input$char1,],
                          locationvar="County", colorvar="percent",
                          options=list(region="IE", displayMode="markers", 
                                       resolution="provinces",
                                       colorAxis="{colors:['#4daf4a','blue']}",
                                      magnifyingGlass.enable="{enable: true, zoomFactor: 7.5}"
                          ))
    
    print(gvisMerge(geochart,bar,horizontal=FALSE))
  })
  
  #update variable and group based on dataset
  output$variable <- renderUI({ 
    obj<-switch(input$dataset,
                "Counties_numbers" = Counties_numbers)   
    var.opts<-namel(colnames(obj))
    selectInput("variable","Variable:", var.opts) # uddate UI     		 
  }) 

  output$linech <- renderGvis({
    OSM <- switch(input$OSM,    
                  "OSM_ALL"   = tab$OSM_ALL,
                  "OSM_S"      = tab$OSM_S,
                  "OSM_G"      = tab$OSM_G,
                  "OSM_O"      = tab$OSM_O,
                  "OSM_P"     =  tab$OSM_P,
                  "OSM_I"      = tab$OSM_I,
                  "OSM_Q"      = tab$OSM_Q)
    
    GEODIR <- switch(input$GEODIR,    
                     "GEODIR_ALL" = tab$GEODIR_ALL,
                     "GEODIR_S"   = tab$GEODIR_S,
                     "GEODIR_G"   = tab$GEODIR_G,
                     "GEODIR_O"   = tab$GEODIR_O,
                     "GEDOIR_P"   = tab$GEDOIR_P,
                     "GEODIR_I"   = tab$GEODIR_I,
                     "GEODIR_Q" =  tab$GEODIR_Q)  
    
    #### Plots ###
    
    df=data.frame(County=tab$County, 
                  OSM=OSM, 
                  GEODIR=GEODIR)
    
    Line <- gvisLineChart(df,"County", c("OSM","GEODIR"),
                          options=list(
                            title="OSM and GEODIR line chart Comparison by County (Numbers)",
                              vAxis="{title:'Totals'}",                         
                            titlePosition='out',
                            hAxis="{slantedText:'true',slantedTextAngle:90}",
                            titleTextStyle="{color:'black',fontName:'Courier'}",
                            legend="{color:'black',fontName:'Courier'}",
                            fontSize="10"
                          ))
    
    return(Line)
    
  })
  output$barch <- renderGvis({
    OSM <- switch(input$OSM,    
                  "OSM_ALL"   = tab$OSM_ALL,
                  "OSM_S"      = tab$OSM_S,
                  "OSM_G"      = tab$OSM_G,
                  "OSM_O"      = tab$OSM_O,
                  "OSM_P"     =  tab$OSM_P,
                  "OSM_I"      = tab$OSM_I,
                  "OSM_Q"      = tab$OSM_Q)
    
    GEODIR <- switch(input$GEODIR,    
                     "GEODIR_ALL" = tab$GEODIR_ALL,
                     "GEODIR_S"   = tab$GEODIR_S,
                     "GEODIR_G"   = tab$GEODIR_G,
                     "GEODIR_O"   = tab$GEODIR_O,
                     "GEDOIR_P"   = tab$GEDOIR_P,
                     "GEODIR_I"   = tab$GEODIR_I,
                     "GEODIR_Q" =  tab$GEODIR_Q)      
    
    #### Plots ###
    
    df=data.frame(County=tab$County, 
                  OSM=OSM, 
                  GEODIR=GEODIR)
    
    Column <- gvisColumnChart(df,"County", c("OSM","GEODIR"), options=list(
      title="GEODIR and OSM bar plot comparison by County (Numbers)",
      hAxis="{slantedText:'true',slantedTextAngle:90}",
      vAxis="{title:'Totals'}",
     # hAxis="{title:'OSM'}",
      titleTextStyle="{color:'black',fontName:'Courier'}",

      fontSize="10"))
        
    return(Column)    
  })
  
  output$scatterch <- renderGvis({
    OSM <- switch(input$OSM,    
                  "OSM_ALL"   = tab$OSM_ALL,
                  "OSM_S"      = tab$OSM_S,
                  "OSM_G"      = tab$OSM_G,
                  "OSM_O"      = tab$OSM_O,
                  "OSM_P"     =  tab$OSM_P,
                  "OSM_I"      = tab$OSM_I,
                  "OSM_Q"      = tab$OSM_Q)
    
    GEODIR <- switch(input$GEODIR,    
                     "GEODIR_ALL" = tab$GEODIR_ALL,
                     "GEODIR_S"   = tab$GEODIR_S,
                     "GEODIR_G"   = tab$GEODIR_G,
                     "GEODIR_O"   = tab$GEODIR_O,
                     "GEDOIR_P"   = tab$GEDOIR_P,
                     "GEODIR_I"   = tab$GEODIR_I,
                     "GEODIR_Q" =  tab$GEODIR_Q)  
    
    #### Plots ###
    dat <- data.frame(cbind(OSM=OSM,"OSM GEODIR"=GEODIR))
    SC <- gvisScatterChart(dat, 
                           options=list(
                             #hAxis.title="OSM",
                             vAxis.title="OSM",
                             title="GEODIR v OSM scatter plot comparison (Numbers)",
                             vAxis="{title:'GEODIR'}",
                             hAxis="{title:'OSM'}",
                             legend="none",
                             pointSize=10,
                             series="{
                             0: { pointShape: 'circle', color: 'black' }
  }",
                             titleTextStyle="{color:'black',fontName:'Courier'}",
                             
                             fontSize="10"))
  
    
    return(SC)
    
})

output$bubblech <- renderGvis({
  OSM <- switch(input$OSM,    
                "OSM_ALL"   = tab$OSM_ALL,
                "OSM_S"      = tab$OSM_S,
                "OSM_G"      = tab$OSM_G,
                "OSM_O"      = tab$OSM_O,
                "OSM_P"     =  tab$OSM_P,
                "OSM_I"      = tab$OSM_I,
                "OSM_Q"      = tab$OSM_Q)
  
  GEODIR <- switch(input$GEODIR,    
                   "GEODIR_ALL" = tab$GEODIR_ALL,
                   "GEODIR_S"   = tab$GEODIR_S,
                   "GEODIR_G"   = tab$GEODIR_G,
                   "GEODIR_O"   = tab$GEODIR_O,
                   "GEDOIR_P"   = tab$GEDOIR_P,
                   "GEODIR_I"   = tab$GEODIR_I,
                   "GEODIR_Q" =  tab$GEODIR_Q)   
  #### Plots ###
  
  df=data.frame(County=tab$County, 
                OSM=OSM, 
                GEODIR=GEODIR,
                Percentage_Completeness=(round((OSM/GEODIR)*100)))
  
  Bubble <- gvisBubbleChart(df, idvar="County", 
                            xvar="OSM", yvar="GEODIR",
                            colorvar="County", sizevar="Percentage_Completeness",
                            options=list(
                              pointSize=5,
                              hAxis='{minValue:75, maxValue:125}',
                              chartArea= "{width: '100%', height: '100%'}",
                             # width=1000, height=800,                           
                              bubble="{textStyle:{color: 'none'}}",
                             titleTextStyle="{color:'black',fontName:'Courier'}",
                             
                             fontSize="10"))
  
  
  return(Bubble)
  
})

output$histch <- renderGvis({
  OSM <- switch(input$OSM,    
                "OSM_ALL"   = tab$OSM_ALL,
                "OSM_S"      = tab$OSM_S,
                "OSM_G"      = tab$OSM_G,
                "OSM_O"      = tab$OSM_O,
                "OSM_P"     =  tab$OSM_P,
                "OSM_I"      = tab$OSM_I,
                "OSM_Q"      = tab$OSM_Q)
  
  GEODIR <- switch(input$GEODIR,    
                   "GEODIR_ALL" = tab$GEODIR_ALL,
                   "GEODIR_S"   = tab$GEODIR_S,
                   "GEODIR_G"   = tab$GEODIR_G,
                   "GEODIR_O"   = tab$GEODIR_O,
                   "GEDOIR_P"   = tab$GEDOIR_P,
                   "GEODIR_I"   = tab$GEODIR_I,
                   "GEODIR_Q" =  tab$GEODIR_Q)  
  #### Plots ###
  
  df=data.frame(County=tab$County, 
                OSM=OSM, 
                GEODIR=GEODIR,
                Percentage_Completeness=(round((OSM/GEODIR)*100)))
  data <- df[as.numeric(df$County),c("OSM", "GEODIR")]
  
  Histogram <- gvisHistogram(data, option=list(title="Frequeny Distribution of County Totals",
                                               legend="{ position: 'none' }",
                                               colors="['#5C3292', '#1A8763', '#871B47']",
                                               titleTextStyle="{color:'black',fontName:'Courier'}",
                                               hAxis="{title:'Totals'}",
                                               
                                               fontSize="10")) 
  return(Histogram)
  
})


output$density= renderPlot({
  
  df= out[(out$Category)==input$dens1,]
  dg= out[(out$Category)==input$dens2,]
  Cat=rbind(df,dg)
  Cat=as.data.frame(Cat)
  Categories=Cat$Category
  p<-qplot(Cat$Totals, data=Cat, geom="density", xlim = c(0, 7500), y=..scaled..,fill=Cat$Category, alpha=I(.5), 
           main="pdf Distribution of County Totals", xlab="County Totals", 
           ylab="Density")
  
  
  density<-print(p)
  
  return(density)
  
})
  


output$distPlot <- renderPlot({
  
  OSM <- switch(input$OSM,    
                "OSM_ALL"   = tab$OSM_ALL,
                "OSM_S"      = tab$OSM_S,
                "OSM_G"      = tab$OSM_G,
                "OSM_O"      = tab$OSM_O,
                "OSM_P"     =  tab$OSM_P,
                "OSM_I"      = tab$OSM_I,
                "OSM_Q"      = tab$OSM_Q)
  
  GEODIR <- switch(input$GEODIR,    
                   "GEODIR_ALL" = tab$GEODIR_ALL,
                   "GEODIR_S"   = tab$GEODIR_S,
                   "GEODIR_G"   = tab$GEODIR_G,
                   "GEODIR_O"   = tab$GEODIR_O,
                   "GEDOIR_P"   = tab$GEDOIR_P,
                   "GEODIR_I"   = tab$GEODIR_I,
                   "GEODIR_Q" =  tab$GEODIR_Q) 
  
  x <- OSM 
  y <- GEODIR
  
  binsx <- seq(min(x), max(x), length.out = input$binsx + 1)
  binsy <- seq(min(y), max(y), length.out = input$binsy + 1)
  hist(x, breaks = binsx, col=rgb(1,0,0,0.5), border = 'white',main="Overlapping Histogram", xlab="Frequency Distribution of OSM and GEODIR")
  hist(y, breaks = binsy, col=rgb(0,0,1,0.5), border = 'white',add=TRUE)
  box()
})



})
