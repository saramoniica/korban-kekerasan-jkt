
header <- dashboardHeader(
  title = "Analisa Korban Kekerasan"
)

sidebar <- dashboardSidebar(
  collapsed = F,
  sidebarMenu(
    menuItem(
      text = "Overview",
      tabName = "Overview",
      icon = icon("globe-asia")
    ),
    menuItem(
      text = "Analisa",
      tabName = "Analisa",
      icon = icon("book")
    ),
    menuItem("Source Code", icon = icon("file-code-o"), 
             href = "https://github.com/saramoniica/korban-kekerasan-jkt")
  )
)

body <- dashboardBody(
  
  shinyDashboardThemes(
    theme = "purple_gradient"
  ),
  
  tabItems(
    
    # TAB 1  
    
    tabItem(
      tabName = "Overview",
      fluidPage(
        h2(tags$b("Kasus Kekerasan di Jakarta")),
        br(),
        div(style = "text-align:justify", 
            p("Kasus kekerasan saat ini menjadi momok yang serius bagi masyarakat Indonesia, terutama Provinsi Jakarta. 
              Dalam kurun waktu 2019-2020, kasus kekerasan di Jakarta mengalami penurunan sebesar 3,5%, 
              di mana angka laporan kasus kekerasan pada tahun 2019 sebanyak 988 kasus dan pada tahun
              2020 sebanyak 956 kasus. Penurunan kasus yang terjadi secara tidak signifikan.", 
              "Dari sebanyak 956 kasus hanya 510 kasus yang dilaporkan kepada pihak berwenang"),
            br()
        )
      ),
      fluidPage(
        box(width = 8,
            title = "Perbandingan Jumlah Kasus Tahun 2019 - 2020",
            plotlyOutput("plot1")
        ),
        valueBox("510", 
                 "Kasus yang Melapor", 
                 icon = icon("city"),
                 color = "green"),
        valueBox("446",
                 "Kasus yang Tidak Lapor",
                 icon = icon("book"),
                 color = "red")
      ),
      fluidPage(
        box(width = 8,
            title = "Korban menurut Jenis Kelamin Per Bulan",
            plotlyOutput("plotbulan")
        ),
        box(width = 4,
            height = 425,
            h3("Korban Kekerasan tahun 2020"),
            div(style = "text-align:justify",
                p("Analisa kali ini mengambil data yang berasal dari Open Data Jakarta yang menitik beratkan 
                  kasus ini kepada para Korban yang merupakan Perempuan serta Anak-anak"),
                br(),
                p("Grafik menunjukkan Korban kekerasan didominasi oleh korban yang berjenis kelamin perempuan 
                  dan yang paling tinggi dan Kasus paling banyak terjadi di bulan Juni 2020"),
                br(),
                p(a(href = "https://data.jakarta.go.id/dataset/",
                    "Open Data Jakarta"))
            )
          )
        )
      ),
    
    # TAB 2
    
    tabItem(
      tabName = "Analisa",
      fluidPage(
        box(width = 4,
            solidHeader = T,
            title = "Perbandingan Tingkat Pendidikan Korban dan Pelaku Kekerasan", 
            plotlyOutput("plotpend")),
        box(width = 4,
            solidHeader = T,
            title = "Perbandingan Jenis Pekerjaan Korban dan Pelaku Kekerasan", 
            plotlyOutput("plotpekerjaan")),
        box(width = 4,
            solidHeader = T,
            title = "Perbandingan Usia  Korban dan Pelaku Kekerasan", 
            plotlyOutput("plotusia"))
      ),
      fluidPage(
      box(width = 12,
            selectInput(
              inputId = "input_category",
              label = "Pilih Kategori",
              choices = unique(pbjt_long$kategori)
            )),
      box(title = "Akumulasi berdasarkan Bentuk Kekerasan dan Jenis Kekerasan di Jakarta Tahun 2020",
            solidHeader = T,
            width = 12,
            plotlyOutput("plotbentukjenis"))
      )
    )
  )
)


# Combining Dashboard Part
dashboardPage(
  header = header,
  body = body,
  sidebar = sidebar
)
