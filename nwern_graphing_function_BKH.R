#Import your data sheet from DIMA as is

RH_DIMA_export_December082020 <- readxl::read_excel("RH_DIMA_export_December082020.xlsx", sheet = "Aeolian")
TV_DIMA_export_December082020 <- readxl::read_excel("TV_DIMA_export_December082020.xlsx", sheet = "Aeolian")

### lets create a function????

nwern_graphing = function(x, do.NULL = TRUE)
{
  if (is.data.frame(x))
  
  x[,c("Plot", "Type of sampler", "Sample Archived", "Notes", "Sample Compromised", "Sediment g/day")] = NULL
  colnames(x) [c(3:8)] = c("Height (cm)", "Deployed", "Collected", "Weight", "Period", "Flux_cm2_day")
  
  #This helps with graphing later
  x$Collected = as.Date(x$Collected)
  
  #create column to scale flux to g/m2/day
  x$flux_m = x$Flux_cm2_day * 10000

  library(dplyr)
  
  #average height within blocks
  x_block = x %>%
    tidyr::separate("Location", into = c("block", "num"), sep = 1) %>%
    group_by(Site, Collected, Deployed, `Height (cm)`, block) %>%
    summarise(flux_m2 = mean(flux_m,  na.rm = T))
  
  #average among blocks
  flux_graph = x_block %>%
    group_by(Site, Deployed, Collected, `Height (cm)`) %>%
    summarise(
      Flux_m2 = mean(flux_m2,  na.rm = T),
      sd.flux = sd(flux_m2, na.rm = T),
      se.flux = sd(flux_m2, na.rm=T)/sqrt(length(flux_m2[!is.na(flux_m2)])))
  
  flux_graph$`Height (cm)` = as.factor(flux_graph$`Height (cm)`)
  
  #create a data frame to graphically show when site was established, and each time a collection occurred
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
          panel.border = element_rect(colour = "black", fill=NA, size=0.5))
  
  return(graph)
}


nwern_graphing(x = RH_DIMA_export_December082020)

nwern_graphing(x = TV_DIMA_export_December082020)
