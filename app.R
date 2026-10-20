# https://www.color-hex.com/color-palette/1039605
# https://colordrop.io/palette/63568
# earth greens



library(htmltools)
library(shiny)
library(echarts4r)
library(bslib)
library(readxl)
library(tidyverse)
library(reactable)
library(fst)
library(leaflet)

library(watcher)

load("cost_charts.RData")

system("ls -lh")        # list files
system("echo Hello!")   # print message

source('./components/footer.R')
source('./components/legend.R')
source('./components/disabled_risk_to_intervene_on.R')
source('./components/hatched_sub_title.R')
source('./components/scenarios_div.R')
# source('./cost_graphs.R')



source('modules/startup_overlay/startup_overlay_div.R')
# source('modules/specificInterventionModule_3.R')
# source('modules/chart_update_module_3/chart_update_module.R')
# source('modules/intervention_module2/intervention_module.R')
source('modules/slide_panel_module/slide_panel_module.R')

# source('load_graphs_sppg.R')
# source('chtgpt_banner_metrics_suggestion2.R')
# source('sppg_div.R')

# x <- stroke_age20[[2]]
# x$dependencies = NULL
# x <- x |> e_hide_grid_lines()

print('#################################')
print(system.file(package = "sparkline"))
print(dir(system.file("htmlwidgets/lib", package = "sparkline")))
print(file.exists(system.file("htmlwidgets/lib/jquery.sparkline/jquery.sparkline.min.js", package = "sparkline")))

print('#################################')

lapply(ls(globalenv()), function(x){
  y <<- x
  obj <- get(x)
  print(x)
  if('echarts4r' %in% class(obj) ){
    print('T')

    if(!is.null(obj$x$theme) & obj$x$theme != ''){
      print(obj$x$theme)
      # print(x)
      # print(obj$x$theme)
      # obj$dependencies[[1]]$src$file <- system.file("htmlwidgets/lib/echarts-6.0.0/themes", package = "echarts4r")#htmltools::htmlDependency(name = obj$x$theme, version = "1.0.0",
      #                         src = system.file("htmlwidgets/lib/echarts-6.0.0/themes", package = "echarts4r"),
      #                        script = paste0(obj$x$theme, ".js")
      # )
      
      obj$dependencies[[1]] <-  htmltools::htmlDependency(name = obj$x$theme, version = "1.0.0", 
                                                          src = system.file("htmlwidgets/lib/echarts-6.0.0/themes", package = "echarts4r"),
                                                          script = paste0(obj$x$theme, ".js")
      )
      
      
      # x<<-obj
      # print (obj)
      assign(x, obj, envir = globalenv())
    }}
  
})

print('#################################')


graph_wrapper <- function(..., header =NULL){
  
  div(class = "grid-item grid-item--graph theme-cyan",
      div(class = "grid-item-content",
          div(class = "chart-card",
              if(!is.null(header)){
                div(class = "card-header",# style = "font-size: 0.5em;",
                    header
                )},
              ...
          )
      )
  )
}

# theme_x <- readLines('theme.json')

ui <- page_fluid(
  theme = bs_theme(version = 5,
                   bootswatch = 'litera',
                   font_scale = 0.9,
                   primary = 'black',
                   success = '#00bcd4'),
  
  startup_overlay_div(5000,7000),
  slide_panel_ui('slide',panel_title = 'Hello, Write text and collect graphs here by drag and dropping'),
 
  div(id = 'main-content', #class = "visually-hidden",
      
      #style = "opacity:0;",
#       tags$head(
#         tags$link(rel = "stylesheet", href = "https://cdnjs.cloudflare.com/ajax/libs/ion-rangeslider/2.3.1/css/ion.rangeSlider.min.css"),
#         # Custom CSS styling
#         tags$style("
# 
# .irs-line {
#     /* background: linear-gradient(0.25turn, #3cb3716e, #ffa5007a, #ff00006b); */ 
#     background: linear-gradient(0.25turn, #3cb371e8, white, #00b0ff) !important;
#   }
#   
#  .irs-bar {
#     background: #ffffffbf !important;
#   }
# 
# .selectize-input{
#     max-height:75px;
#     overflow-y:auto;
# }
# 
# accordion-button.collapsed {
#     transition:background 3s ease-in-out;
#     background:white; 
#     }
# 
# .accordion-button:not(.collapsed) {
#     transition:background 3s ease-in-out;
#     background: linear-gradient(140deg, var(--bs-success), 5%, white);
#     border-radius:12px
# }
# 
# .accordion-button{
#     transition:background 3s ease-in-out;
#     background: linear-gradient(10deg, var(--bs-success), 25%, white);
#     border-radius:12px
# }
# 
# .accordion,.accordion-item{
#     border: solid white 2px;
#     }
# 
#  /* * { box-sizing: border-box; } */
# 
# html{font-size:70%}
# ")),
      
      # Main layout container
      
      # Control Panel
      
      div(class = 'w-100 navbar p-0 fixed-top border-0 d-flex gap-0 flex-column flex-wrap glass-card',
          shiny::tags$nav(
            #style='position:fixed;top:0px;left:0px',
            class = "navbar w-100 glass-card p-3 rounded", # bg-light mt-5
            shiny::h4(  "Population Health", span(class = 'lead','Public Health Agency'),
                        
                        HTML('<h7><span class="badge rounded-pill bg-opacity-75 bg-success "> Monetary Expense </span></h7>'),
                        HTML('<h7><span class="badge rounded-pill bg-opacity-75 bg-success ">Disease Burden </span></h7>'),
                        HTML('<h7><span class="badge rounded-pill bg-opacity-75 bg-success ">Cost Effectiveness </span></h7>'),
                        
                        span(HTML('<h7><span class="badge rounded-pill text-white bg-opacity-75 bg-primary">PHA', '' ,'</span></h7>')),
                        span(HTML('<h7><span class="badge rounded-pill text-white bg-opacity-75 bg-primary">', 'Trusts' ,'</span></h7>')),
                        HTML('<h7><span class="badge rounded-pill bg-opacity-75 bg-secondary ">Population Health Model </span></h7>'),
                        HTML('<h7 id = "move" style = "float:right;">
                       <!-- <a href="https://apply-for-innovation-funding.service.gov.uk/competition/2186/overview/e51c18bc-21b3-450d-bdbc-2f43dad3b268">
                       <span class="badge rounded-pill bg-light">
                        <i class="fa-solid fa-arrow-up-right-from-square"></i>
                       OPIP bid</span>
                       </a> -->
                       </h7>'),
                        class = "navbar-brand mb-0 w-100"
            )
          ),
          
          # div(class='mt-5 pt-5'),##position:fixed;top:0px;
          HTML('<nav id = "top-top"
                                  style = "width:100%;
                                  margin-inline:-12px;backdrop-filter: blur(5px);
                                  /*background: #00D4FF;
                                  background: linear-gradient(55deg, orange 55%, #FFD700 87%); */
                                  background: linear-gradient(55deg, #00bcd4 15%, #4dd0e1 100%);",

                                  class=" w-100 bg-gradient-blue-cyan bg-opacity-50">
                      <div class="text-white">
                      <div id ="top-nav-content" class="d-flex gap-5 justify-content-center align-items-center">
                      <a href="#overview-section" class="nav-item bg-opacity-100 nav-iten p-1 px-4 rounded-pill text-white">
                      <i class="fas fa-tachometer-alt"></i>
                      <span class="fs-6">Overview</span>
                      </a>
                      <i class="fa-solid fa-chevron-right"></i>
                      <a href="#evidence-section" class="nav-item bg-opacity-100 nav-iten p-1 m-3 px-4 rounded-pill text-white">
                      <i class="fas fa-exclamation-triangle"></i>
                      <span class="fs-6">Research</span>
                      </a>
                      <i class="fa-solid fa-chevron-right"></i>
                      <a href="#prevalence-section" class="nav-item bg-opacity-100 nav-iten p-1 m-3 px-4 rounded-pill text-white">
                      <i class="fas fa-tachometer-alt"></i>
                      <span class="fs-6">Reports</span>
                      </a>
                      <!-- <a href="#incidence-section" class="nav-item bg-opacity-100 nav-iten p-1 px-4 rounded-pill text-white">
                      <i class="fas fa-map-marked-alt"></i>
                      <span class="fs-6">Incidence</span>
                      </a>
                      <a href="#downstream-section" class="nav-item bg-opacity-100 nav-iten p-1 m-3 px-4 rounded-pill text-white">
                      <i class="fas fa-users"></i>
                      <span class="fs-6" > Dashboard</span> -->
                      </a>
                      </div>
                      </div>
                      </nav>')
          
      ),
      
tags$nav(
  id = "scrollspy-nav",
  class = "nav flex-column align-items-stretch nav-pills position-absolute position-sticky float-left",
  style = 'width:14vw; z-index:100; top:20vh; left:2%;',
  `data-bs-spy` = "scroll",
  `data-bs-target` = "#scrollspy-nav",
  `data-bs-offset` = "0",
  tabindex = "0",
  
  ######################################################
  
  div(class = "nav-section",
      h6(class = "bg-opacity-100 border-5  p-2 rounded-3  text-bg-dark text-light", "Non-communicable Disease "), #text-body-secondary
  ),
  #############################################
  
  tags$a(class = "nav-link active", href = "#intro", "Intro", `data-value` = "interactive"),
  
  tags$a(class = "nav-link", href = "#daly", "Disability Adjusted Life Years", `data-value` = "interactive"),
  
  tags$div(class = "nav flex-row ms-3 my-1",
           tags$a(class = "nav-link", href = "#daly", tags$b('DALY'), `data-value` = "interactive"),
           tags$a(class = "nav-link", href = "#yll", tags$b('YLL'), `data-value` = "interactive"),
           tags$a(class = "nav-link", href = "#yld", tags$b('YLD'), `data-value` = "interactive"),
           # tags$a(class = "nav-link", href = "#stroke_trust", icon('globe'), `data-value` = "interactive"),
           # tags$a(class = "nav-link", href = "#stroke_MDMquintile", icon('comments-dollar'), `data-value` = "interactive")
  ),
  
  tags$a(class = "nav-link", href = "#society", "Costs and service use", `data-value` = "interactive"),
  tags$div(class = "nav flex-row ms-3 my-1 justify-content-center w-75",
           div(class=  'd-flex flex-column w-50',
           tags$a(class = "nav-link text-center", href = "#sick-spells", tags$b(icon('face-dizzy')), `data-value` = "interactive"),
           tags$a(class = "nav-link text-center", href = "#sick-costs", tags$b(icon('filter-circle-dollar')), `data-value` = "interactive"),
           tags$a(class = "nav-link text-center", href = "#days-lost", tags$b(icon('hourglass')), `data-value` = "interactive")
           ),
           div(class = 'd-flex flex-column w-50',
           tags$a(class = "nav-link text-center", href = "#bed-days", tags$b(icon('bed-pulse')), `data-value` = "interactive"),
           tags$a(class = "nav-link text-center", href = "#admissions", tags$b(icon('user')), `data-value` = "interactive"),
           tags$a(class = "nav-link text-center", href = "#emergency-admissions", tags$b(icon('user-clock')), `data-value` = "interactive")
           ),
  ),
  tags$a(class = "nav-link", href = "#money", "Disease and Healthcare Costs ", `data-value` = "interactive"),
  tags$div(class = "nav flex-row ms-3 my-1 justify-content-center w-75",

               tags$a(class = "nav-link text-center", href = "#disease-costs", tags$b(icon('dollar-sign')), `data-value` = "interactive"),
  ),
  
  tags$a(class = "nav-link", href = "#multimorbidity", "Multimorbidity", `data-value` = "interactive"),
  
  tags$div(class = "nav flex-row ms-3 my-1 w-75",
           # tags$a(class = "nav-link", href = "#cmms-gp", icon('table'), `data-value` = "interactive"),
           tags$a(class = "nav-link", href = "#cmms", tags$b('CMMS'), `data-value` = "interactive"),
           # tags$a(class = "nav-link", href = "#cmms-death", icon('table'), `data-value` = "interactive"),
           tags$a(class = "nav-link", href = "#cmms-age", icon('chart-simple'), `data-value` = "interactive")#,
  #          tags$a(class = "nav-link", href = "#count_risk_phys", tags$b('CMMS'), `data-value` = "interactive"),
  #          tags$a(class = "nav-link", href = "#count_disease", icon('table'), `data-value` = "interactive"),
  #          tags$a(class = "nav-link", href = "#count_disease2", icon('wave-square'), `data-value` = "interactive"),        
  #          tags$a(class = "nav-link", href = "#count_disease3", icon('chart-diagram'), `data-value` = "interactive")
  )
  ),
      
      div(class = "main-container", `data-bs-spy` = "scroll", `data-bs-target` = "#top-nav-content", `data-bs-offset` = "70",
          # div(class='mt-5 pt-5')
          # Main content area
          div(class = "content-area",
              # div( class="tab-pane active", id="overview", role="tabpanel", `aria-labelledby`="overview",
              
              div(class = "tab-content",
                  
                  # Dashboard Tab Content
                  
                  div(id = "dashboard-tab", class = "tab-pane show active", #
                      
                      div(class = "container-fluid",
                          style = "padding-left: 0%;padding-top:8%;padding-right:3%",
                          
                          div(
                            tags$head(
                              
                                # Include external dependencies
                                # Custom CSS styling
                              includeCSS('./www/app_layout.css'),
                              HTML("<link rel='stylesheet' href='progress_bar.css' />"),
                              includeCSS('./www/css/scrollspy.css')
                            ),
                            
                            tags$head(
                              includeScript("./www/js/scrollspy.js"),
                              includeScript("./www/js/pm25_sources_chart.js"),
                              includeScript("./www/js/tab_navigation.js")
                              
                            ),
                            
                            # Scrollspy Nav
                            
                            # div( class="row",
                            #   div( class="col-2",
                            #div(style='',class = ' ms-2 p-3 d-flex flex-row',#shadow-sm glass-card
                            
                            div(class = 'bg-white rounded-3',style = 'margin-left:7%;margin-right:3%;margin-top:5%;padding-inline:2%;min-height:100vh;',
                                id = "scrollspy-content",
                                `data-bs-spy` = "scroll",
                                `data-bs-target` = "#scrollspy-nav",
                                #`data-bs-offset` = "0",
                                #tabindex = "0",
                                style = "position: relative; overflow-y: auto; scroll-behavior: smooth;", # height: 100vh;
                                
                                
                                tags$div( id = "intro",
                                          h2('Cost and Impact Analysis for Decision Support and Public Health Planning ',class = 'm-5 p-3 text-info'),
                                          hr(),
                                          tags$span(class ='',"The Impact and Costing module of the Population Health Model supports Decision Making and
                                                    Public Health Planning for the Public Health Agency.
                                                    It includes Non-Communicable Disease of the", tags$b('Respiratory,'),tags$b('MSK,'), tags$b('Cancer,'), tags$b('Neurodegenerative'), 'and', tags$b('Cardiovascular'), " systems.",
                                                    "It allows evaluation of the savings as a result of public health interventions as well as projection of costs and burden into the further"
                                                    ),
                                          
                                          h3('Definitions',class = 'm-5 p-3 border-bottom border-top border-success'),
                                          
                                
                                          
                                          tags$div(id = "item-11",class = 'pb-3',
                                                   tags$h4(class = 'd-inline', 'Deaths'),
                                                   tags$span(class = 'd-inline text-secondary',
                                                             "asthma, chd, colorectal_cancer, copd, dementia, diabetes, female_breast_cancer, heart_failure, kidney_disease, lung_cancer, ovarian_cancer, pancreatic_cancer, prostate_cancer, stroke, uterine_cancer")
                                             
                                          ),
                                          
                                          tags$div(id = "item-2",class = 'pb-3',
                                                   tags$h4(class = 'd-inline', 'Disability'),
                                                   tags$span(class = 'd-inline text-secondary',
                                                             "stroke, chd, diabetes, hypothyroidism, asthma, copd, non_diabetic_hyperglycaemia, chronic_kidney_disease, dementia, heart_failure, lung_cancer, prostate_cancer, female_breast_cancer, colorectal_cancer, atrial_fibrillation, rheumatoid_arthritis, osteoarthritis, epilepsy, osteoporosis, renal_cancer, oesophageal_cancer, stomach_cancer, oral_cancer, pancreatic_cancer ,uterine_cancer, ovarian_cancer, blood_cancer")
                                          ),

                                          tags$div(id = "item-4",class = 'pb-3',
                                                   tags$h4(class = 'd-inline','Costs'),
                                                   tags$span(class = 'd-inline',"Are defined per healthcare scope only. No indirect costs")
                                          ),
                                          
                                          tags$div(id = "item-5",class = 'pb-3',
                                                   tags$h4(class = 'd-inline','Productivity'),
                                                   tags$span(class = 'd-inline',"is measured for societal losses extrapolated from civil service statistics"),
                                                   
                                                   tags$div(id = "item-5-1",
                                                            # tags$h5("Note 1"),
                                                            tags$span("")
                                                   ),
                                                   tags$div(id = "item-5-2",
                                                            # tags$h5("Note 2"),
                                                            tags$span(style='font-weight:bold;',"")
                                                   ),
                                                   tags$div(id = "item-5-3",
                                                            #tags$h5("Note 3"),
                                                            tags$span(style='font-weight:bold;',"")
                                                   ),
                                                   # tags$div(id = "item-5-4",
                                                   #          #tags$h5("Note 4"),
                                                   #          tags$span("Number of patients aged 18 or over with CKD with classification of categories G3a to G5 (previously stage 3 to 5).")
                                                   # ),
                                                   tags$div(id = "item-5-5",
                                                            #tags$h5("Note 5"),
                                                            tags$span("")
                                                   ),
                                                   tags$div(id = "item-5-6",
                                                            #tags$h5("Note 6"),
                                                            tags$span("")
                                                   )
                                          ),
                                          
                                          tags$div(id = "disability_adjusted_life_years", class = 'py-5 mt-5 ',
                                                   
                                                   div(class = 'border-top border-bottom border-success m-5 p-3',
                                                       tags$h3(class = 'd-inline',"Disease Burden"),
                                                       tags$span(class = 'd-inline',"Quantity and Quality of Life losses as a result of Disease")
                                                       ),
                                                   
                                                   tags$div(id = "daly", class = 'd-flex flex-column align-items-center  gap-2',
                                                            #tags$h5("Cancer - Note 1"),
                                                            # tags$span(style='font-weight:bold;',"Because of the date cut-off in the definition of this register, prevalence trends are obscured by the increase in the size of the register due to the cumulative accrual of new cancer cases onto practice registers with each passing year.")
                                                            
                                                            div(class= 'w-100 d-flex flex-column align-items-center gap-2 p-2' ,style = 'height:500px;',
                                                                tags$h3(
                                                                         "Disbability Adjusted Life Years attributable to Individual Disease, at Present Time"),
                                                                disease_daly_start_charts),
                                                            
                                                            div(class= 'w-100 d-flex flex-column align-items-center gap-2 p-2' ,style = 'height:600px;',
                                                                tags$h3(
                                                                  "Disbabillty Adjusted Life Years over Time attributable to individual Disease"),
                                                                
                                                            disease_daly_time_charts
                                                            ),
                                                            
                                                            div(class= 'w-100 d-flex flex-column align-items-center gap-2 p-2 ' ,style = 'height:600px;',
                                                                tags$h3(
                                                                  "Quantity and Quality of Life losses as a Result of Disease, for each Disease, at Present"),
                                                            total_dalys_chart
                                                            )
                                                   ),
                                                   tags$div(id = "yll",
                                                            #tags$h5("Cancer - Note 1"),
                                                            # tags$span(style='font-weight:bold;',"Because of the date cut-off in the definition of this register, prevalence trends are obscured by the increase in the size of the register due to the cumulative accrual of new cancer cases onto practice registers with each passing year.")
                                                            div(class= 'w-100 d-flex flex-column align-items-center gap-2 p-4 ' ,style = 'height:600px;',
                                                                tags$h3(
                                                                  "Years of Life Lost as a Result of Disease, for each Disease"),
                                                                yll_time_chart
                                                                )
                                                   ),
                                                   tags$div(id = "yld",
                                                            #tags$h5("Cancer - Note 1"),
                                                            # tags$span(style='font-weight:bold;',"Because of the date cut-off in the definition of this register, prevalence trends are obscured by the increase in the size of the register due to the cumulative accrual of new cancer cases onto practice registers with each passing year.")
                                                            div(class= 'w-100 d-flex flex-column align-items-center gap-2 ' ,style = 'height:600px;',
                                                                tags$h3(
                                                                  "Severity Weighted Quality of Life as attributable to Disease, for each Disease "),
                                                            yld_time_chart
                                                                )
                                                   )
                                          ),
                                          tags$section(
                                            id = "society",
                                            class = "pt-5",
                                            h2("Societal Productivity and Societal Impact", class = "m-5 p-3 border-bottom border-top border-info"),
                                            tags$div(id = "sick-spells", class = "pt-4", style = 'height:300px',
                                                     h3("Sick spells"),
                                                     sick_spells_chart
                                                     ),
                                            tags$div(id = "sick-costs", class = "pt-4", style = 'height:300px',
                                                     h3("Sickness costs"),
                                                     sick_costs_chart
                                                     ),
                                            tags$div(id = "days-lost", class = "pt-4", style = 'height:300px',
                                                     h3("Days lost"),
                                                     days_lost_chart
                                                     ),
                                            tags$div(id = "bed-days", class = "pt-4", style = 'height:300px',
                                                     h3("Bed days"),
                                                     bed_days_chart
                                                     ),
                                            tags$div(id = "admissions", class = "pt-4", style = 'height:300px',
                                                     h3( "Admissions"),
                                                     admissions_chart
                                                     ),
                                            tags$div(id = "emergency-admissions", class = "pt-4", style = 'height:300px',
                                                     h3( "Emergency admissions"),
                                                     emergency_admissions_chart
                                                     ),
                                      
                                          ),
                                          
                                          tags$section(
                                            id = "money",
                                            class = "py-5 my-5 vh-75",
                                            
                                            h2("Cost", class = "m-5 p-3 border-bottom border-top border-info"),
                                          
                                          tags$div(id = "disease-costs", class = "pt-4",  style = 'height:400px',
                                                   h3("Costs by disease"),
                                                   costs_disease_chart
                                          ) 
                                          
                                          ),
                                          
                                          tags$div(id = "multimorbidity", class = 'py-5 mt-5 ',
                                                   
                                                   div(class = 'border-top border-bottom border-success m-5 p-3',
                                                       tags$h3(class = 'd-inline',"Multimorbidity"),
                                                       
                                                       tags$span(class = 'd-inline',"Correlation and Co-morbid Conditions")
                                                       ),
                                                       
                                                       tags$div(id = "cmms", class = "pb-5 mb-5", #style = 'height:300px',
                                                                h5("Multimorbidity: Cambridge Multimorbidity Score by Age"),
                                                                
                                                                div(  style = 'height:300px',cmms_age10_chart),
                                                               
                                                                 div(class="d-block text-dark bg-white fs-5 p-3 rounded-2 my-2 opacity-100 shadow-sm",
                                                                    h6(class = 'd-inline','Cambridge Multimorbidity Score'),
                                                                    span(class='d-inline text-secondary',
                                                                         'The Cambridge Multimorbidity Score (CMMS) is a morbidity weighted sum of 20 morbidities, based on severiety of disease,
                                                                         propensity for sufferers to present for unplanned emergency admission, GP appointment or have premature Death.
                                                                         '))
                                                       ),
                                                       tags$div(id = "cmms-age", class = "my-4 p-5 rounded-5 bg-success-subtle ", style = 'height:500px;',
                                                                h3("Multimorbidity: Count of Morbidity by age"),
                                                                multimorbidity_age10_chart 
                                                       )
                                                    
                                                   ),
                                          
                                          # tags$div(id = "society",
                                          #         #  tags$h5("Sources of Environmental Risk"),
                                          #            h4('Sources',class = 'm-5 p-3 border-bottom border-top border-success'),
                                          #          tags$span(class ='lead',"The contributing sources of differing types of pollution"),br(),br(),
                                          #                 h4('PM2.5',class = 'm-5 p-3 border-bottom border-top border-success'),
                                          #                   tags$span(class ='lead',"Particulate Matter, or dust, that is 2.5 microns across is the most impactful to non-Communicable Disease Health."),
                                          #                   tagList(
                                          #                     HTML("<div id='main' style='width:100%;height:400px'></div>"),
                                          #                 
                                          #                   )
                                          #          )
                                          ),
                                          # tags$div(id = "item-9-1",
                                          #          h4('PM2.5 Exposure distribution',class = 'm-5 p-3 border-bottom border-top border-success'),
                                          #          tags$span(class ='lead',""),
                                          # div(class = 'mx-5 px-5',
                                          # 
                                          #   # pollution_map_app
                                          # 
                                          # )
                                          # ),
                                          tags$div(id = "item-10",
                                                  
                                          div(id = "Links",class='min-vh-25 p-5 m-5 w-75',
                                              div(class="text-dark bg-white fs-5 p-3 rounded-2 my-5 opacity-100 shadow-sm", h5(class = 'd-inline','Links'), span(class='d-inline text-secondary','Resources that prove useful')),
                                              # div(class='justify-content-evenly min-vh-50 flex-wrap',#grid
                                                  # d-flex flex-row gap-2 py-5
                                                  
                                                  # div(class = "grid-item nav-card float-left analytics bg-opacity-50",
                                                  #     div(onclick = "window.open('https://www.airqualityni.co.uk/air-quality/health-effects','_blank')",
                                                  #         class = "nav-card-icon",
                                                  #         icon("arrow-up-right-from-square")),
                                                  #     div(class = "nav-card-title", "Air Quality NI"),
                                                  #     div(class = "nav-card-description text-wrap ", "Northern Ireland 2023 Air Quality Health Impact Report"),
                                                  # ),
                                                  # div(class = "grid-item nav-card float-left settings bg-opacity-50",
                                                  #     div(onclick = "window.open('https://www.gov.uk/government/publications/health-matters-air-pollution/health-matters-air-pollution','_blank')",
                                                  #         class = "nav-card-icon",
                                                  #         icon("arrow-up-right-from-square")),
                                                  #     div(class = "nav-card-title", " UK Gov"),
                                                  #     div(class = "nav-card-description", "Guidance on Health impact of Air pollution"),
                                                  # ),
                                                  

                                                  # tags$h5("Resources"),
                                                  # tags$span("Resources"),
                                              #     tags$div(id = "item-10-1",
                                              #              # tags$h5("Note 1"),
                                              #              # tags$span("Resources"),
                                              #              
                                              #              lapply(
                                              #                list(
                                              #                  list('NI Air Quality', 'https://www.airqualityni.co.uk/uploads/reports/66fe5c057bf6f-air-pollution-in-northern-ireland-2023-issue1-screen-optimised-672399cdd209a620008745.pdf'),
                                              #                  # list(2, 'https://www.airqualityni.co.uk/air-quality/health-effects'),
                                              #                  list('Microsimulation', 'https://www.sciencedirect.com/science/article/pii/S0048969719340823'),
                                              #                  # list(4, 'https://www.gov.uk/government/publications/health-matters-air-pollution/health-matters-air-pollution'),
                                              #                  # list(5, 'https://static-content.springer.com/esm/art%3A10.1038%2Fs41366-021-00849-8/MediaObjects/'),
                                              #                  list('London Risk Modelling', 'https://erg.ic.ac.uk/research/home/resources/ERG_ImperialCollegeLondon_HIA_AQ_LDN_11012021.pdf'),
                                              #                  list('Polluton and the National Health Service', 'https://journals.plos.org/plosmedicine/article?id=10.1371/journal.pmed.1002602'),
                                              #                  list('Costs of Pollution', 'https://assets.publishing.service.gov.uk/media/5afef7a0e5274a4be3231bd0/Estimation_of_costs_to_the_NHS_and_social_care_due_to_the_health_impacts_of_air_pollution_-_summary_report.pdf'),
                                              #                  list('Romanian Modelling', 'https://www.sciencedirect.com/science/article/pii/S2214750022000506'),
                                              #                  list('Pollution and Stroke', 'https://www.ahajournals.org/doi/10.1161/STROKEAHA.122.035498')
                                              #                ) |> (\(x) Map(c, x, seq_along(x)))(),
                                              #                function(r) {
                                              #                  div(class = paste("grid-item nav-card float-left bg-opacity-50",
                                              #                                    if (r[[3]] %% 2 == 1) "analytics" else "settings"),
                                              #                      div(onclick = sprintf("window.open('%s','_blank')", r[[2]]),
                                              #                          class = "nav-card-icon",
                                              #                          icon("arrow-up-right-from-square")),
                                              #                      div(class = "nav-card-title",  r[[1]]),
                                              #                      div(class = "nav-card-description", sub("^https?://([^/]+).*", "\\1", r[[2]]))
                                              #                  )
                                              #                }
                                              #              )
                                              # )
                                              #)
                                                  # div(class = "grid-item nav-card float-bottom w-25 reports bg-opacity-50",
                                                  #     div(onclick = "$('.tab-pane').removeClass('active show');$('#' + 'research-tab').addClass('active show');",
                                                  #         class = "nav-card-icon",
                                                  #         icon("arrow-up-right-from-square")),
                                                  #     div(class = "nav-card-title", "Go to Scenarios"),
                                                  #     div(class = "nav-card-description", " Intervene on population risk"),
                                                  # ),
                                                  # # 
                                                  # div(class = "grid-item nav-card float-bottom w-25 reports bg-opacity-50",
                                                  #     div(onclick = "  $('.tab-pane').removeClass('active show');$('#' + 'reports-tab').addClass('active show');",
                                                  #         class = "nav-card-icon",
                                                  #         icon("arrow-up-right-from-square")),
                                                  #     div(class = "nav-card-title", "Go to intervene tab"),
                                                  #     div(class = "nav-card-description text-wrap ", "Rudimentary estimates of devolved nations, adult and children adhd prevalence"),
                                                  # 
                                                  # ),
                                                  ),
                                                  
                                                  # 
                                                  # div(class = "grid-item nav-card float-left settings bg-opacity-50",
                                                  #     div(onclick = "window.open('https://digital.nhs.uk/data-and-information/publications/statistical/mi-adhd/may-2025','_blank')",
                                                  #         class = "nav-card-icon",
                                                  #         icon("arrow-up-right-from-square")),
                                                  #     div(class = "nav-card-title", "NHS England"),
                                                  #     div(class = "nav-card-description", "Experimental Mental Health Statistics"),
                                                  # )
                                              
                                          ),
                                ),
                            ),
                                       
                                          div(id = "outro", class = "pt-5", h2("Notes")),
                            
                      )
                      ),
                  
                  div(id = "reports-tab", class = "tab-pane ", #
                      
                      div(class = 'm-5 pt-5', 
                          style = 'padding-left:15%;width:800px;',
                          sm_hatched_subtitle('Scenarios')
                      ),
                      scenarios_div()
                  )
                  
                  ),# End of dashboard grid
                  
   #       div(id = "research-tab", class = "tab-pane ", #
              
  #             #div(class = 'col-9',
  #             
  #             # Scrollspy content container — requires height and overflow
  #             div(style = 'padding-left:12%;padding-top:5%;margin-left:3%;',
  #                 id = "scrollspy-content",
  #                 `data-bs-spy` = "scroll",
  #                 `data-bs-target` = "#scrollspy-nav",
  #                 #`data-bs-offset` = "0",
  #                 #tabindex = "0",
  #                 style = "position: relative; overflow-y: auto; scroll-behavior: smooth;", # height: 100vh;
  #                 
  #                 # Stroke Section,
  #                 
  #                 div(id = "stroke", class = "pt-5", h2("Select Intervention")),
  #                 
  #                 ################################################################
  #                 interventionSelectorUI("people_intervention_selector"),
  #                 div(class = "row g-2 align-items-start",
  #                     div(class = "col-6",
  #                         intervention_module_ui("intensity_intervention_selector", chart_height = "220px")
  #                     ),
  #                     div(class = "col-6",
  #                         chartUpdateModuleUI("loading_scenarios_chart")
  #                     )
  #                 ),
  #                 
  #                 h2("Risk to modulate"),
  #                 disabled_risk_to_intervene,
  #                 
  #                 actionButton(inputId = 'reset', label = 'Reset ', icon = icon('rotate-left'), class = 'float-right'),
  #                 actionButton(class='float-right pb-2 mb-3 ',
  #                              inputId = 'run_intervention_w_selectors','Run Intervention',
  #                              icon = icon('play')),
  #                 
  #                 
  #                 ################################################################
  #                 
  #                 
  #                 
  #                 
  #                 
  #                 
  #                 
  #                 div(id = "Intervention", class = "pt-5", h2("Risk to intervene on")),
  #                 selectizeInput(
  #                   inputId = "disease",
  #                   label = "Disease",
  #                   choices = character(0),
  #                   selected = NULL,
  #                   options = list(
  #                     valueField = "email",
  #                     labelField = "name",
  #                     render = I("{
  #   item: function(item, escape) {
  #     console.log(item);
  #     var name = item.email ? '<span class=\"name\">' + item.email + '</span>' : '';
  #     return '<div class =  m-2 p-2>' + '<span class=\"email m-2\">' + item.name + '</span></div>';
  #   },
  #   option: function(item, escape) {
  #     var label = item.name || item.email;
  #     var caption = item.name ? item.email : null;
  #     return '<div class =  \"m-2 p-2 rounded-3 \">' +
  #      (caption ? '<span class=\"label\">' + item.email + '</span>' : '') 
  #       
  #     '</div>';
  #   }
  # }") 
  #                   )),
  #                 
  #                 
  #                 
  #             )
  #             
  #             
  #         
  #         
  #         
  #  ),
                  
                  
              ),#, # End of dashboard tab content
              
      
              
          ) # End of tab-content-container
          
      ), # Close content-area
      
      # Initialize Packery with Click and Expand JavaScript
      
      footer()
  )

# ============================================================================
# SERVER
# ============================================================================

server <- function(input, output, session) {
  
#   runButton <- reactiveVal(NULL)
#   
#   observeEvent(input$run_intervention_w_selectors,ignoreInit = T,ignoreNULL=T,{
#     runButton(input$run_intervention_w_selectors + 1)
#   })
#   
#   pop_reactive <- reactive(
#     past_populations %>% 
#       filter(year==min(year),run==1)
#   )
#   
#   api <- interventionSelectorServer("people_intervention_selector", data = pop_reactive)
#   
#   targeted_pop <- reactive(
#     {
#       reached <- api$data () %>% filter(intervention_reached ==T)
#       targets <- api$data () %>% filter(intervention_target ==T)
#       
#       print(count(api$data(),intervention_reached))
#       print(count(api$data(),intervention_target))
#       print(count(reached,intervention_reached))
#       print(count(targets,intervention_target))
#       
#       print(  past_populations %>% 
#                 mutate(intervention_target = ifelse(id %in% targets$id,T,F)) %>% 
#                 mutate(intervention_reached = ifelse(id %in% reached$id,T,F)) %>% 
#                 summarise(sum(intervention_target)/n()*100,
#                           sum(intervention_reached)*100/n() )
#       )
#       
#       past_populations %>% 
#         mutate(intervention_target = ifelse(id %in% targets$id,T,F)) %>% 
#         mutate(intervention_reached = ifelse(id %in% reached$id,T,F))
#     }
#   )
#   
#   result <- intervention_module_server("intensity_intervention_selector", 
#                                        reactive({runButton()}
#                                                 ))
#   
#   simulation_state <- chartUpdateModuleServer("loading_scenarios_chart", 
#                                               reactive({runButton()}),
#                                               targeted_pop(),
#                                               input$draggable_data
#                                               )
# 
#   output_df <- reactiveVal({past_populations})
#     
# observe({ 
#   
#     # print(simulation_state$past_populations())
#     
#     # print(simulation_state$simulation_active)
# 
#     if(nrow(simulation_state$results())>0){
#       
#       message('run data packet')
#       
#       target_populations_df <- simulation_state$results()
#       
#       t_past_populations <- targeted_pop() %>% 
#         filter(run <= model_specification$model$number_of_runs ) %>%
#         filter(year <= max(target_populations_df$year) &
#                  year >= min(target_populations_df$year)
#         ) %>%
#         # take out runs and year previously, but not now modelled
#         filter(intervention_reached) %>%
#         # take out runs those that are targeted
#         bind_rows(target_populations_df ) %>%
#         # put in those that are targeted
#         mutate(intervention = 'intervention')
#       # mark as an intervention
#       
#       t_past_populations <- t_past_populations %>% 
#         select(-any_of( c('cmms', 'multimorbidity'))) %>% 
#         compute_cmms() %>% 
#         add_multimorbidity_fn()
#       
#       total_pop <- bind_rows(
#         targeted_pop() %>% 
#           filter(run <= max(target_populations_df$run) ) %>%
#           filter(year <= max(target_populations_df$year) &
#                    year >= min(target_populations_df$year)
#           ) %>%
#           mutate(intervention = 'non-intervention'),
#         t_past_populations
#       )
#       
#       # total_pop <- compute_cmms(total_pop)
#       # total_pop <- add_multimorbidity_fn(total_pop)
#       
#       qsave(total_pop, 'total_pop.qs')
#       output_df(total_pop)
#       
#     }else{
#       
#       message('no run yet')
#       output_df(past_populations)
#       
#     }
#     
#     
#     output$stroke_incidence_chart <- renderEcharts4r({
#       # req(simulation_state$past_populations())
#       message('stroke plot')
#       # simulation_state$past_populations() %>%
#       
#       # simulation_state$results()  %>%
#       
#       output_df() %>% 
#      # simulation_state$past_populations() %>% 
#         # simulation_result() %>%
#         mutate(year = as.character(year)) %>% 
#         filter(stroke == year) %>%
#         count(run, intervention, year) %>%
#         # group_by(intervention, year) %>%
#         # summarise(n = mean(n)) %>%
#         # mutate(year = as.character(year),
#         #        n = n*model_specification$population$scale_down_factor) %>%
#         # group_by(intervention) %>% 
#         e_charts(year) %>%
#         e_line(n) %>%
#         e_tooltip(trigger = "axis") %>%
#         e_theme("walden") %>%
#         e_y_axis(name = "Average Count") %>%
#         e_grid(containLabel = TRUE) %>%
#         e_x_axis(name = "Year")
#     })
#     
#     
#     
#     
#   })
#   
#   
#   observeEvent(TRUE, {
#     updateSelectizeInput(session, 
#                          inputId='disease', 
#                          selected = 'stroke',
#                          choices = y
#     )
#   })
  
  
  
}
shiny::devmode()
shinyApp(ui = ui, server = server)
