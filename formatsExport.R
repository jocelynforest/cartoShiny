# formatsExport

# formats 4:3
format4_3 <- data.frame(
  x_pixel=c(320,320,400,480,640,768,800,960,
            1024,1200,1280,1400,1600,1920,2048,2276,2560),
  y_pixel=c(240,480,300,360,480,576,600,720,
            768,900,960,1050,1200,1440,1536,1707,1920),
  nom=c('QVGA','HVGA','','','VGA','PAL','SVGA','',
        'XGA','','','SXGA','UXGA','','QXGA','','')
)

# format page
paperSizeA <- data.frame(
  nom=paste0('A', 0:10),
  x_mm=c(841,594,420,297,210,148,105,74,52,37,26),
  y_mm=c(1189,841,594,420,297,210,148,105,74,52,37)
)
paperSizeA["x_in"] <- round(paperSizeA[2]/25.4, 2)
paperSizeA["y_in"] <- round(paperSizeA[3]/25.4, 2)