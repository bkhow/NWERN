#Import your data sheet from DIMA as is

rh_flux_hgt <- readxl::read_excel("RedHills_DIMA_Flux_output_Dec2020.xlsx", sheet = "Aeolian")

#head(rf_flux_hgt)

### lets create a function????

nwern_graphing = function(x, do.NULL = TRUE)
{
  ## Delete unnecessary columns and rename
  if (is.data.frame(x))
  x[,c(2,5,9,11,12,13)] = NULL
  colnames(x) [c(3:7)] = c("Height (cm)", "Deployed", "Collected", "Weight", "Flux_cm2")
  
  #This helps with graphing later
  x$Collected = as.Date(x$Collected)
  
  #create column to scale flux to g/m2/day
  x$flux_m = x$Flux_cm2 * 10000

  library(dplyr)
  
  #I think I'll need to average first within block, then among blocks?? 
  flux_graph = x %>%
    group_by(Site, Deployed, Collected, `Height (cm)`) %>%
    summarise(
      Flux_m2 = mean(flux_m,  na.rm = T),
      sd.flux = sd(flux_m, na.rm = T),
      se.flux = sd(flux_m, na.rm=T)/sqrt(length(flux_m[!is.na(flux_m)])))
  
  flux_graph$`Height (cm)` = as.factor(flux_graph$`Height (cm)`)
  
  dates_collect = data.frame(site = rep(flux_graph$Site), date = flux_graph$Collected, deploy = flux_graph$Deployed)
  mind = min(as.Date(flux_graph$Deployed))
  maxd = max(as.Date(flux_graph$Collected))
  
  library(ggplot2)
  
  graph = ggplot(data = flux_graph, aes(x = Collected, y = Flux_m2)) +
    geom_vline(aes(xintercept = date), data = dates_collect, linetype = "solid", color = "grey", size = 0.75) +
    geom_vline(aes(xintercept = mind), size = 1) +
    geom_hline(aes(yintercept = 0)) +
    coord_cartesian(xlim = c(mind, maxd), expand = TRUE) +
    geom_line(size = 0.5, aes(linetype = `Height (cm)`)) +
    geom_point() +
    geom_errorbar(aes(ymin = if_else(Flux_m2 - se.flux < 0, 0, Flux_m2 - se.flux), ymax = Flux_m2 + se.flux)) +
    labs(title = x$Site, y = expression("Horizontal Sediment Flux" ~~~ (g ~ m^{-2} ~ day^{-1}))) +
    scale_x_date(date_labels = "%b %y",
                 date_breaks = "1 month") +
    theme_classic() +
    theme(axis.text.y = element_text(size = 10, color = "black"),
          axis.title.y = element_text(size = 12, color = 'black'),
          axis.text.x = element_text(angle = 40, hjust = 1, size = 10, color = "black"),
          axis.title.x = element_blank(),
          strip.text = element_text(size = 12),
          panel.border = element_rect(colour = "black", fill = NA, size = 0.5))
  
  return(graph)
}

nwern_graphing(x = rh_flux_hgt)

tv_flux_hgt <- readxl::read_excel("TwinValley_DIMA_Flux_output_Dec2020.xlsx", sheet = "Aeolian")

nwern_graphing(x = tv_flux_hgt)
