shinyServer(function(input, output) {
  
  ##-----Plot 1 
  output$plot1 <-  renderPlotly({
    
    perbandingan_lapor <- pivot_longer(perbandingan_lapor, -jenis_lapor) %>%
      pivot_wider(name, names_from="jenis_lapor", values_from="value") %>% 
      rename(tahun=name)
    perbandingan_lapor <- perbandingan_lapor %>% rowwise() %>% mutate(total_korban = sum(c_across(2:3)))
    perbandingan_lapor <- perbandingan_lapor %>% mutate(label=glue("Total: {total_korban}"))

    plot1 <- ggplot(perbandingan_lapor, aes(x=tahun, y=total_korban, group = 1)) +
      geom_area( fill="pink", alpha=0.4) +
      geom_line(color="red", size=2)+
      geom_point(size=3, color="#0a0306", aes(text=label)) +
      scale_x_discrete(labels=c("total_2019" = "2019", "total_2020" = "2020")) +
      theme_ipsum() +
      labs(title = "Kasus Kekerasan 2019 - 2020",
           x = "Tahun",
           y = NULL)
   ggplotly(plot1, tooltip = "text")

  })
  
  ##-------- Plot 2 = 
  output$plotbulan <- renderPlotly({
    
    jenis_korban_bulan <- jenis_korban_bulan %>% 
      group_by(yearmonth, jenis_kelamin) %>% 
      summarise(total=sum(jumlah_klien)) %>% 
      ungroup() %>%
      arrange(total)

    jenis_korban_bulan <- jenis_korban_bulan %>% 
      mutate(label =glue("Jenis Kelamin :{jenis_kelamin}
                     Total: {comma(total)}"))
    # Plot
    plotbulan <- jenis_korban_bulan %>%
      ggplot(aes(x=yearmonth, y= total, fill=jenis_kelamin)) +
      geom_area(position = "identity", colour="black", size=0.2, alpha=.4) +
      geom_point(aes(text=label)) +
      scale_fill_viridis(discrete = TRUE, option = "C") +
      labs(x = NULL,
           y = NULL,
           fill = NULL) +
      theme_minimal() +
      theme(legend.position="top")

    ggplotly(plotbulan, tooltip = "text")
  })
  
  ##--------- Plot Pendidikan = 
  output$plotpend <- renderPlotly({
    
    pendidikan <- pendidikan %>% na.omit() 
    pendidikan <- pendidikan %>% rename( tingkat_pendidikan = pendidikan_klien_dan_pelaku , korban = jumlah_korban_kekerasan_thd_perempuan_dan_anak_berdasarkan_pendidikan_klien, pelaku = jumlah_korban_kekerasan_thd_perempuan_dan_anak_berdasarkan_pendidikan_pelaku )
    pendidikan <- pivot_longer(data = pendidikan,
                                     cols = c("korban","pelaku"),
                                     names_to = "terlibat")
    
    pendidikan$yearmonth <- as.yearmon(pendidikan$yearmonth, "%Y-%m")
    pendidikan$value <- as.numeric(pendidikan$value)
    pendidikan$tingkat_pendidikan <- as.factor(pendidikan$tingkat_pendidikan)
    pendidikan$terlibat <- as.factor(pendidikan$terlibat)
    
    pendidikan <- pendidikan %>%
      rename(total = value) %>% 
      group_by(tingkat_pendidikan, terlibat) %>% 
      summarise(total_korban = sum(total)) %>% 
      ungroup()
      
    pendidikan <- pendidikan  %>% mutate(label =glue(" Terlibat: {terlibat}
                         Total : {total_korban}"))
    
    plotpend <- ggplot(data = pendidikan, mapping = aes(x = tingkat_pendidikan, y = total_korban, text = label, fill = terlibat))+
      geom_bar(position = "dodge", stat = "identity")+
      scale_fill_viridis(discrete = T, option = "A") +
      labs(x = NULL,
           y = NULL,
           fill = NULL) +
      theme(legend.title = element_blank(),
            axis.text.x = element_text(angle = 30, hjust = 1),
            plot.title = element_text(face = "bold"),
            panel.background = element_rect(fill = "#ffffff"),
            axis.line.y = element_line(colour = "grey"),
            axis.line.x = element_blank(),
            panel.grid = element_blank()) +
      theme(axis.text.x = element_text(angle = 45, hjust=1), legend.position = "none")
    
    ggplotly(plotpend, tooltip="text")
  })

  ##--------- Plot Pekerjaan = 
  output$plotpekerjaan <- renderPlotly({
    
    pekerjaan <- pekerjaan %>% rename( jenis_pekerjaan = pekerjaan_klien_dan_pelaku , korban = jumlah_korban_kekerasan_thd_perempuan_dan_anak_berdasarkan_jenis_pekerjaan_klien, pelaku = jumlah_korban_kekerasan_thd_perempuan_dan_anak_berdasarkan_jenis_pekerjaan_pelaku)
    pekerjaan <- pivot_longer(data = pekerjaan,
                               cols = c("korban","pelaku"),
                               names_to = "terlibat")
    
    pekerjaan$yearmonth <- as.yearmon(pekerjaan$yearmonth, "%Y-%m")
    pekerjaan$value <- as.numeric(pekerjaan$value)
    pekerjaan$jenis_pekerjaan <- as.factor(pekerjaan$jenis_pekerjaan)
    pekerjaan$terlibat <- as.factor(pekerjaan$terlibat)
    
    pekerjaan <- pekerjaan %>%
      rename(total = value) %>% 
      group_by(jenis_pekerjaan, terlibat) %>% 
      summarise(total_korban = sum(total)) %>% 
      ungroup() %>% 
      mutate(label =glue(" Terlibat: {terlibat}
                         Total : {total_korban}"))
    
    plotpekerjaan <- ggplot(data = pekerjaan, mapping = aes(x = jenis_pekerjaan, y = total_korban, text = label, fill = terlibat))+
      geom_bar(position = "dodge", stat = "identity")+
      scale_fill_viridis(discrete = T, option = "C") +
      labs(x = NULL,
           y = NULL,
           fill = NULL) +
      theme(legend.title = element_blank(),
            axis.text.x = element_text(angle = 30, hjust = 1),
            plot.title = element_text(face = "bold"),
            panel.background = element_rect(fill = "#ffffff"),
            axis.line.y = element_line(colour = "grey"),
            axis.line.x = element_blank(),
            panel.grid = element_blank()) +
      theme(axis.text.x = element_text(angle = 35, hjust=1), legend.position = "none")
    
    ggplotly(plotpekerjaan, tooltip="text")
  })

  ##--------- Plot Pekerjaan = 
  output$plotusia <- renderPlotly({
    
    usia <- usia %>% rename(range_usia = usia_klien_dan_pelaku , korban = jumlah_korban_kekerasan_thd_perempuan_anak_berdasarkan_usia_klien, pelaku = jumlah_korban_kekerasan_thd_perempuan_anak_berdasarkan_usia_pelaku )
    usia <- pivot_longer(data = usia,
                              cols = c("korban","pelaku"),
                              names_to = "terlibat")
    
    usia$yearmonth <- as.yearmon(usia$yearmonth, "%Y-%m")
    usia$value <- as.numeric(usia$value)
    usia$range_usia <- as.factor(usia$range_usia)
    usia$terlibat <- as.factor(usia$terlibat)
    
    usia <- usia %>%
      rename(total = value) %>% 
      group_by(range_usia, terlibat) %>% 
      summarise(total_korban = sum(total)) %>% 
      ungroup() %>% 
      mutate(label =glue(" Terlibat: {terlibat}
                         Total : {total_korban}"))
    
    plotusia <- ggplot(data = usia, mapping = aes(x = range_usia, y = total_korban, text = label, fill = terlibat))+
      geom_bar(position = "dodge", stat = "identity")+
      scale_fill_viridis(discrete = T, option = "F") +
      labs(x = NULL,
           y = NULL,
           fill = NULL) +
      theme(legend.title = element_blank(),
            axis.text.x = element_text(angle = 30, hjust = 1),
            plot.title = element_text(face = "bold"),
            panel.background = element_rect(fill = "#ffffff"),
            axis.line.y = element_line(colour = "grey"),
            axis.line.x = element_blank(),
            panel.grid = element_blank()) +
      theme(legend.position = "none")
    
    ggplotly(plotusia, tooltip="text")
  })
  
  ##--------- Plot BENTUK JENIS= 
  output$plotbentukjenis <- renderPlotly({
      pbjt_long <- pbjt_long[!(is.na(pbjt_long$value) | pbjt_long$jenis==""), ]
      pbjt_long <- pbjt_long  %>%  filter(kategori == input$input_category) %>% 
        mutate(label =glue("Total : {value}"))
    
    plotbentukjenis <- ggplot(pbjt_long, aes(fill=jenis, y=value, x=jenis, text = label)) + 
      geom_bar(position="dodge", stat="identity") +
      scale_fill_viridis(discrete = T, option = "C") +
      facet_wrap(~kategori, scales="free") +
      labs(title = NULL,
           x = NULL,
           y = NULL,
           fill = NULL) +
      theme(legend.title = element_blank(),
            axis.text.x = element_text(angle = 30, hjust = 1),
            plot.title = element_text(face = "bold"),
            panel.background = element_rect(fill = "#ffffff"),
            axis.line.y = element_line(colour = "grey"),
            axis.line.x = element_blank(),
            panel.grid = element_blank()) +
      theme(axis.text.x = element_text(angle = 20, hjust=0.1), legend.position = "none")
    
    ggplotly(plotbentukjenis, tooltip="text")
  }) 
})
