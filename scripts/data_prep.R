library(tidyverse)

trams.df <- read_csv("data/Metrolink_Station_Facilities_cleaned.csv")

trams.format.df <- trams.df %>% 
  pivot_longer(cols = -variable,
               names_to = "stop",
               values_to = "var") %>% 
  pivot_wider(values_from = var,
              names_from = variable) %>% 
  arrange(stop)

trams.geo.df <- read_csv("data/TfGMMetroRailStops.csv")

trams.geo.df <- trams.geo.df %>% 
  arrange(RSTNAM)

# trams.geo.df has no Woodlands Road tram station because it no longer exists
# trams.geo.df has no Mosley Street tram station because it no longer exists

# trams.format.df had no Exchange Square or Queens Road but I added them manually

trams.format.geo.df <- trams.format.df %>% 
  filter(stop != "Woodlands Road" & stop != "Mosley Street") %>% 
  bind_cols(trams.geo.df) %>% 
  select(stop, RSTNAM, Line, NPTREF:GMGRFN, MAINRD:NETWRF, lifts:bb_spaces) %>% 
  arrange(Line)

names(trams.format.geo.df) <- tolower(names(trams.format.geo.df))

write_csv(x = trams.format.geo.df, path = "data/trams_geo.csv")
