 library(ggrepel)
 
 p1 <- ggplot( data = one.data );
 p1 <- p1 + geom_point( aes( plot_X, plot_Y, colour = log10_p_value, size = plot_size), alpha = I(0.6) ) + scale_size_area();
 p1 <- p1 + scale_colour_gradientn( colours = c("blue", "green", "yellow", "red"), limits = c( min(one.data$log10_p_value), 0) );
 p1 <- p1 + geom_point( aes(plot_X, plot_Y, size = plot_size), shape = 21, fill = "transparent", colour = I (alpha ("black", 0.6) )) + scale_size_area();
 p1 <- p1 + scale_size( range=c(5, 30)) + theme_bw(); # + scale_fill_gradientn(colours = heat_hcl(7), limits = c(-300, 0) );
 ex <- one.data [ one.data$dispensability < 0.15
                  | grepl("meiotic",one.data$description)
                  | grepl("flower",one.data$description)
                  | grepl("floral",one.data$description)
                  | grepl("ovary",one.data$description)
                  | grepl("ovule",one.data$description)
                  | grepl("pollen",one.data$description)
                  | grepl("carpel",one.data$description)
                  | grepl("ethylene",one.data$description)
                  | grepl("siRNA",one.data$description)
                  | grepl("pistil",one.data$description)
                  | grepl("stamen",one.data$description)
                  | grepl("androecium",one.data$description)
                  | grepl("anther",one.data$description)
                  ,];
 ex <- ex [ !grepl("animal",ex$description)
            & !grepl("muscle",ex$description)
            & !grepl("BMP",ex$description)
            & !grepl("cancer",ex$description)
            & !grepl("liver",ex$description)
            & !grepl("MHC",ex$description)
            & !grepl("T cell",ex$description)
            & !grepl("renal system",ex$description)
            ,];
 # ADDDDDDDDDDDDDDDDDDD
 p1 <- p1 + geom_text_repel( data = ex, aes(plot_X, plot_Y, label = description), colour = I(alpha("red", 0.85)), size = 5 );
 p1 <- p1 + labs (y = "semantic space x", x = "semantic space y");
 p1 <- p1 + theme(legend.key = element_blank()) ;
 one.x_range = max(one.data$plot_X) - min(one.data$plot_X);
 one.y_range = max(one.data$plot_Y) - min(one.data$plot_Y);
 p1 <- p1 + xlim(min(one.data$plot_X)-one.x_range/10,max(one.data$plot_X)+one.x_range/10);
 p1 <- p1 + ylim(min(one.data$plot_Y)-one.y_range/10,max(one.data$plot_Y)+one.y_range/10);
 
 
 
 # --------------------------------------------------------------------------
 # Output the plot to screen
 
 p1;
 ggsave("white.GO.enrichment.pdf",w=11,h=9)