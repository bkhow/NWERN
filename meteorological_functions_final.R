# Packages you will need uploaded to your environment:
## dplyr
## ggplot2
## varhandle

##### take data table from https://winderosionnetwork.org/data-portal/public-data
### and basically reformat for summaries. This function takes time because it's 
### manipulating every single date and mutating into another column. Then creates
### df2 which

daily_means <- function(df) {
  names(df) <- as.character(unlist(df[2,]))
  df1 = df[-c(1:4),]
  df1$TIMESTAMP = strptime(df1$TIMESTAMP, format = "%Y-%m-%d %H:%M:%S")
  df1$date = as.Date(df1$TIMESTAMP, format = "%m/%Y")
  df1[,c(2,3)] = NULL
  df1[,c(2:22)] = varhandle::unfactor(df1[,c(2:22)])

  library(dplyr)
  
  df3 = df1[,c("date", "Total_Rain_mm")]
  
  df2 = df1[,-c(1,6)] %>%
    group_by(date) %>% 
    summarise_all(.funs = mean)
  
  #need to sum precip instead of average
  df4 = df3 %>%
    group_by(date) %>%
    summarise(Total_Rain_mm = sum(Total_Rain_mm))

  return(left_join(df4,df2, by = "date"))
}

################## GRAPHING FUNCTION
#### function to embed into next function. Basically I did this in order to get the name of 
#### the choosen variable on the y-axis
showplot1 <- function(indata, inx, iny){
  p <- ggplot(indata, 
              aes_q(x = as.name(names(indata)[inx]), 
                    y = as.name(names(indata)[iny])))
  p + #geom_point(size=1, alpha = 0.1) +
    geom_line() +
    theme_bw() +
    scale_x_date(date_labels = "%b %y", date_breaks = "1 month") +
    theme(axis.title.x = element_blank(),
          axis.text.x = element_text(angle = 40, hjust = 1, size = 11, color = "black"),
          axis.title.y = element_text(size = 11))
}
#########
#### Daily graph == to graph the daily average of the variable you choose from CR1000 (Table 1) data file
#### daily.df will be the table exported from the "daily.means" function
#### y MUST be in quotes and be exactly as appears in column label (ex. y = "MaxWS6_10M_m/s")
daily_graph = function(daily.df, y) {
  
  tograph = daily.df[,c(1, which(colnames(daily.df) %in% y))]
  print(tograph)
  #
  library(ggplot2)
  
  showplot1(indata = tograph, inx = 1, iny = 2)
}
########

met_variables = names(daily.df)