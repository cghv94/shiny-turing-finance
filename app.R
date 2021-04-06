library(shiny)
library(BatchGetSymbols)
library(plotly)
options(scipen=999)

descarga_bitcoin <- BatchGetSymbols(tickers = "BTC-USD", first.date = "2014-09-15", last.date = Sys.Date(), freq.data = "daily", cache.folder = file.path(tempdir(), "BGS_Cache"))
bitcoin_data <- data.frame(descarga_bitcoin$df.tickers)

descarga_att <- BatchGetSymbols(tickers = "T", first.date = "1983-11-20", last.date = Sys.Date(), freq.data = "daily", cache.folder = file.path(tempdir(), "BGS_Cache"))
att_data <- data.frame(descarga_att$df.tickers)

descarga_ethereum <- BatchGetSymbols(tickers = "ETH-USD", first.date = "2015-08-05", last.date = Sys.Date(), freq.data = "daily", cache.folder = file.path(tempdir(), "BGS_Cache"))
ethereum_data <- data.frame(descarga_ethereum$df.tickers)

# Define UI for data download app ----
ui <- fluidPage(
    HTML("<center>"),
    # App title ----
    titlePanel("Turing Finance"),
    HTML("</center></br></br>"),
    # Sidebar layout with input and output definitions ----
    sidebarLayout(
        
        # Sidebar panel for inputs ----
        sidebarPanel(
            HTML("<center><b>Tickers</b></br></br><p>Choose a ticker</p></center>"),
            # Input: Choose dataset ----
            selectInput("tickers", " ", choices = c("Bitcoin", "AT&T", "Ethereum"))),
        
        # Main panel for displaying outputs ----
        mainPanel(splitLayout(plotlyOutput("grafica")))
    )
)
# Define server logic to display and download selected file ----
server <- function(input, output, session) {
    
    # Reactive value for selected dataset ----
    datasetInput <- reactive({
        switch(input$tickers,
               "Bitcoin" = bitcoin_data,
               "AT&T" = att_data,
               "Ethereum" = ethereum_data)
    })
    
    # Table of selected dataset ----
    output$grafica <- renderPlotly({
        datasetInput() %>% plot_ly(x = ~ref.date, type="candlestick", open = ~price.open, close = ~price.close, high = ~price.high, low = ~price.low)  %>% layout(xaxis = list(title = "Date / Fecha"), yaxis = list(title = "Price / Precio"))
    })
    
}

# Create Shiny app ----
shinyApp(ui, server)
