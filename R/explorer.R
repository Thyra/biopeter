library("shiny")
library("arulesViz")

launchExplorer <- function(transactions, supp = 0.9, conf = 0.9) {

  shinyApp(ui = shinyUI(pageWithSidebar(
      headerPanel("Association Rules"),
      sidebarPanel(
        conditionalPanel(
          condition = "input.samp=='Sample'",
          numericInput("nrule", 'Number of Rules', 500), br()
        ),
        conditionalPanel(
          condition = "input.mytab %in%' c('grouped', 'graph', 'table', 'datatable', 'scatter', 'paracoord', 'matrix', 'itemFreq')",
          radioButtons('samp', label='Sample', choices=c('All Rules', 'Sample'), inline=T), br(),
          sliderInput("supp", "Support:", min=0, max=1, value=supp, step=1/10000), br(),
          sliderInput("conf", "Confidence:", min=0, max=1, value=conf, step=1/10000), br(),
          selectInput('sort', label='Sorting Criteria:', choices=c('lift','confidence','support')), br(), br()
        )
      ),
      mainPanel(
        tabsetPanel(id='mytab',
          # tabPanel('Grouped', value='grouped', plotOutput("groupedPlot", width='100%', height='100%')),
          # tabPanel('Graph', value='graph', plotOutput("graphPlot", width='100%', height='100%')),
          tabPanel('Scatter', value='scatter', plotOutput("scatterPlot", width='100%', height='100%'))
          )
      )
    )),
    
    server = function(input, output) {

      rules <- reactive({
        return(apriori(transactions, parameter=list(supp = input$supp, conf = input$conf, maxlen=10)))
      })

      nR <- reactive({
        nRule <- ifelse(input$samp == 'All Rules', length(rules()), input$nrule)
      })

      output$scatterPlot <- renderPlot({
        plot(sort(rules(), by=input$sort)[1:nR()], method='scatterplot')
      }, height=800, width=800)
    
    }
  )
}
