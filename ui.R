library(shiny)
library(ggplot2)
library(dplyr)

df <- data.frame()
for (i in 1985:2018){
  i_char <- as.character(i)
  file_path <- paste(i_char,".csv", sep = "")
  Data <- read.csv(file = file_path)
  Data['Year'] <- i
  df=rbind(df,Data)
}
df_star<-data.frame()

for (i in 1985:1998){
  dftest<-subset(df,Year==i)
  dftest<-dftest[order(-dftest$PTS),]
  dftest <- dftest[0:30,]
  df_star=rbind(df_star,dftest)
}

for (i in 2000:2011){
  dftest<-subset(df,Year==i)
  dftest<-dftest[order(-dftest$PTS),]
  dftest <- dftest[0:30,]
  df_star=rbind(df_star,dftest)
}

for (i in 2013:2018){
  dftest<-subset(df,Year==i)
  dftest<-dftest[order(-dftest$PTS),]
  dftest <- dftest[0:30,]
  df_star=rbind(df_star,dftest)
}

df_hw<- read.csv("Players.csv")
df_hw$Player=sub("\\*.*", "", df_hw$Player)
df_hw$X <- NULL
df_hw<-unique(df_hw)

df_star$Player=sub("\\\\.*", "", df_star$Player)
df_star$Player=sub("\\*.*", "", df_star$Player)
df_star<-merge(x = df_star, y = df_hw,by = "Player", all.x = TRUE)
df_star$Year=factor(df_star$Year)

df_star[which(df_star$Pos == 'SG-PG'),]$Pos="SG"
df_star[which(df_star$Pos == 'SG-PF'),]$Pos="SG"
df_star[which(df_star$Pos == 'SF-SG'),]$Pos="SF"
df_star[which(df_star$Pos == 'SG-SF'),]$Pos="SG"

data_select <- df_star %>% select(Year, Player, Tm, G, Pos, FG., X3PA, X3P., X2PA, X2P., FTA, FT., ORB, DRB, TRB, AST, STL, BLK, PF, PTS, height, 
                                 weight, collage, born, birth_city, birth_state)
names(data_select) <- c("Year", "Player", "Team", "Games", "Position", "FG_Percent", "Three_Point_Attempt", "Three_Point_Percent", 
                        "Two_Point_Attempt", "Two_Point_Percent", "FT_Attempt", "FT_Percent", "Offensive_Rebounds", "Defensive_Rebounds", "Total_Rebounds", 
                        "Assist", "Steal", "Block", "Foul", "Points", "height", "weight", "college", "born", "birth_city", "birth_state")
data_select$Year <- factor(data_select$Year)

dataset <- data_select

fluidPage(
  
  titlePanel("NBA Explorer"),
  
  sidebarPanel(
    
    sliderInput('start_year', 'Start Year', min=1985, max=2018, value=1985, step=1, round=0),
    sliderInput('end_year', 'End Year', min=1985, max=2018, value=2018, step=1, round=0),
    
    selectInput('x', 'X', names((dataset)['Year'])),
    selectInput('y', 'Y', names((dataset)[, !names(dataset) %in% c("Year", "Position", "Team", "Player", "college", "birth_city", "birth_state")])),
    selectInput('color', 'Color', c('None', names((dataset)[c('Team','Position')]))),
    selectInput('facet', 'Facet', c('None', names((data_select)[c('Team','Position')]))),
    
    checkboxInput('point', 'Point'),
    checkboxInput('line', 'Line'),
    checkboxInput('box', 'Box'),
    checkboxInput('rotate', 'Rotate')
  ),
  
  mainPanel(
    plotOutput('plot')
  )
)