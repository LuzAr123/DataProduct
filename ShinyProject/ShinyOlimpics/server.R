library(shiny)
library(crosstalk)
library(DT)
library(dplyr)
library(tidyverse)
library(ggplot2)

shinyServer(function(input, output, session) {
  
  #### EVENTOS ####
  Events <- athlete_events %>%
    distinct(City, Year, Season) %>%
    arrange(Year)
  
  output$tablaEventos <- renderDataTable({
    dt <- Events %>%
      filter(Year >= input$ChooseYear[1] & Year <= input$ChooseYear[2]) %>%
      filter(City %in% input$selectHost) %>%
      filter(Season %in% input$chkboxSeason)
    dt
  })
  
  observeEvent(input$clean,{
    updatePickerInput(session, 'selectHost', choices = unique(sort(athlete_events$City)),options = list(`actions-box` = TRUE))
    updateSliderInput(session, 'ChooseYear', value = c(min(athlete_events$Year), max(athlete_events$Year)))
    updateCheckboxGroupInput(session, 'chkboxSeason', choices = unique(athlete_events$Season), selected=NULL, inline = TRUE)
  })
  
  #### ATLETAS ####
  
  Atletas <- athlete_events %>%
    distinct(Name, Games)
  Atletas
  
  countAtletas <- Atletas %>%
    select(Name, Games) %>%
    group_by(Name)%>%
    summarise(participacion = n_distinct(Games))
  countAtletas

})
