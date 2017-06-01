# This explorer is based on Andrew Brook's Interactive association rules exploration app
# that can be found at http://brooksandrew.github.io/simpleblog/articles/association-rules-explore-app/
# or https://gist.github.com/brooksandrew/706a28f832a33e90283b if you want to see the code directly.

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
        ),
        conditionalPanel(
          condition ="input.mytab=='grouped'",
          sliderInput('k', label='Choose # of rule clusters', min=1, max=150, step=1, value=15), br()
        ),
        conditionalPanel(
          condition = "input.mytab=='graph'",
          radioButtons('graphType', label="Graph Type", choices=c('itemsets','items'), inline=T), br()
        )
      ),
      mainPanel(
        tabsetPanel(id='mytab',
          tabPanel('Scatter', value='scatter', plotOutput("scatterPlot", width='100%', height='100%')),
          tabPanel('Grouped', value='grouped', plotOutput("groupedPlot", width='100%', height='100%')),
          tabPanel('Graph', value='graph', plotOutput("graphPlot", width='100%', height='100%')),
          tabPanel('Parallel Coordinates', value='paracoord', plotOutput("paracoordPlot", width='100%', height='100%')),
          tabPanel('Raw', value='Table', verbatimTextOutput("rulesTable"))
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
    
      output$groupedPlot <- renderPlot({
        plot(sort(rules(), by=input$sort)[1:nR()], method='grouped', control=list(k=input$k))
      }, height=800, width=800)

      output$graphPlot <- renderPlot({
        plot(sort(rules(), by=input$sort)[1:nR()], method='graph', control=list(type=input$graphType))
      }, height=800, width=800)

      output$paracoordPlot <- renderPlot({
        plot(sort(rules(), by=input$sort)[1:nR()], method='paracoord')
      }, height=800, width=800)

      output$rulesTable <- renderPrint({
        inspect(sort(rules(), by=input$sort))
      })

    }
  )
}
